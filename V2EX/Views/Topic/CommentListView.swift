//
//  CommentListView.swift
//  V2EX
//
//  Created by Benjamin on 2022/10/21.
//

import SwiftUI
import V2exAPI
import MarkdownUI
import Kingfisher

struct CommentListView: View {
  
  @EnvironmentObject private var currentUser: UserStore
  
  var commentCount: Int?
  var commentList: [V2Comment]?
  
  var body: some View {
    Label("\(commentCount ?? 0) 条回复", systemImage: "bubble.middle.bottom.fill")
    
    if (currentUser.user == nil) {
      
      Divider()
      
      Text("请先登录后才能读取回复列表")
        .foregroundColor(.secondary)
      
    } else {
      if let commentList {
        ForEach(commentList) { comment in
          
          Divider()
          
          HStack(alignment: .top) {
            if let avatarUrl = comment.member.avatar {
              KFImage.url(URL(string: avatarUrl))
                .resizable()
                .fade(duration: 0.25)
                .scaledToFit()
                .frame(width: 40, height: 40)
                .mask(RoundedRectangle(cornerRadius: 4))
            }
            
            VStack(alignment: .leading, spacing: 6) {
              HStack {
                if let username = comment.member.username {
                  UserName(username)
                }
                
                if let created = comment.created {
                  Text(Date(timeIntervalSince1970: TimeInterval(created)).fromNow())
                }
              }
              .foregroundColor(Color(UIColor.tertiaryLabel))
              
              Markdown(
                comment.content
                  .replacingOccurrences(
                    of: #"https?.*"#,
                    with: "[$0]($0)",
                    options: .regularExpression,
                    range: nil
                  )
                  .replacingOccurrences(
                    of: #"@(\w+)"#,
                    with: "[$0](https://www.v2ex.com/member/$1)",
                    options: .regularExpression,
                    range: nil
                  )
              )
              .font(.body)
            }
          }
        }
      }
    }
    
  }
}

struct CommentListView_Previews: PreviewProvider {
  static var previews: some View {
    let commentList = [
      PreviewData.comment,
      PreviewData.comment,
      PreviewData.comment
    ]
    CommentListView(commentList: commentList)
      .previewLayout(.fixed(width: 400, height: 200))
  }
}

