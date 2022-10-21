//
//  V2EXApp.swift
//  V2EX
//
//  Created by Benjamin on 2022/10/21.
//

import SwiftUI
import V2exAPI


var v2ex = V2exAPI()

@main

struct V2EXApp: App {
    
    var topic = TopicListView()
    
    
    
    var body: some Scene {
        
        WindowGroup {
            NavigationView {
                topic
            }.navigationViewStyle(.columns)
        }
    }
}
