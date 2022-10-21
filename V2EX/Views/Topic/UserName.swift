//
//  UserName.swift
//  V2EX
//
//  Created by Benjamin on 2022/10/21.
//


import Foundation
import SwiftUI

struct UserName: View {
  
  var username: String
  
  init(_ username: String) {
    self.username = username
  }
  
  var body: some View {
    Button {
      if let url = URL(string: "https://www.v2ex.com/member/\(username)") {
          UIApplication.shared.open(url)
      }
    } label: {
      Text(username)
        .foregroundColor(.secondary)
        .fontWeight(.bold)
        .onHover { inside in
          if inside {
//            NSCursor.pointingHand.push()
          } else {
//            NSCursor.pop()
              
          }
        }
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct UserName_Previews: PreviewProvider {
  static var previews: some View {
    UserName("isaced")
  }
}
