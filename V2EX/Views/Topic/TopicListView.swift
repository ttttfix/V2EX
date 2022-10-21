//
//  TopicListView.swift
//  V2EX
//
//  Created by Benjamin on 2022/10/21.
//

import SwiftUI
import V2exAPI
import Kingfisher

struct TopicListView: View {
    
    var nodeName: String = "ALL"
    var node: V2Node?
    
    @State var isLoading = true
    @State var topics: [V2Topic]?
    @State var page = 1
    @State var error: Error?
    @State var _node: V2Node?
    
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                List {
                    if let topics = topics {
                        ForEach(topics) { topic in
                            TopicListCellView(topic: topic)
                        }
                    if topics.count > 0 && nodeName != "ALL" {
                        ProgressView()
                            .onAppear {
                                Task {
                                    await self.loadData(page: self.page + 1)
                                }
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .frame(minWidth: 400, idealWidth: 500)
                .foregroundColor(.black)
            }
        }.task {
            await loadData()
          }
//          .navigationTitle(_node?.title ?? "V2ex")
          .toolbar {
              KFImage.url(URL(string: _node?.avatarNormal ?? ""))
                .resizable()
                .fade(duration: 0.25)
                .frame(width: 20, height: 20)
                .mask(RoundedRectangle(cornerRadius: 8))
          }
    }
    
    func loadData(page: Int = 1) async {
        if error != nil { return }
        if page == 1 {
            isLoading = true
        }
        do {
            var topics: [V2Topic]? = nil
            if nodeName == "ALL" {
                topics = try await v2ex.latestTopics()
            } else {
                topics = try await v2ex.topics(nodeName: nodeName, page: page)?.result
                _node = try await v2ex.nodesShow(name: nodeName)
            }
            
            if page == 1 {
                self.topics = topics
            } else {
                self.page = page
                if let topics = topics {
                    self.topics?.append(contentsOf: topics)
                }
            }
        }  catch {
            self.error = error
            print(error)
        }
        isLoading = false
    }
}


