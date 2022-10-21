//
//  UserStore.swift
//  V2EX
//
//  Created by Benjamin on 2022/10/21.
//


import Foundation
import SwiftUI
import V2exAPI
import KeychainAccess

public class UserStore: ObservableObject {
  
  public static let shared = UserStore()
  
  @Published public private(set) var user: V2Member?
  @Published public private(set) var accessToken: String? {
    didSet {
      v2ex.accessToken = accessToken
    }
  }
  
  let keychain = Keychain(service: "com.isaced.v2exos")
  let KeychainTokenKey = "AccessToken"
  
  
  
  public init() {
    if let token = readToken(){
      accessToken = token
      
      fetchUser()
    }
  }
  
  public func readToken() -> String? {
    return keychain[KeychainTokenKey]
  }
  
  public func saveToken(token: String) {
    accessToken = token
    keychain[KeychainTokenKey] = token
    
    fetchUser()
  }
  
  func clearToken() {
    do {
      try keychain.remove(KeychainTokenKey)
    }catch {
      print(error)
    }
  }
  
  public func logout(){
    accessToken = nil
    user = nil
    clearToken()
  }
  
  public func checkToken(token: String) async -> Bool {
    do {
      v2ex.accessToken = token
      let res = try await v2ex.token()
      if let tokenObj = res?.result {
        print(tokenObj)
        if let _ = tokenObj.token {
          return true
        }
      }
    }catch{
      print(error)
    }
    v2ex.accessToken = nil
    return false
  }
  
  func fetchUser() {
    Task {
      do {
        if let res = try await v2ex.member(){
          if res.success {
            user = res.result;
          }
        }
      }catch{
        return
      }
    }
  }
}
