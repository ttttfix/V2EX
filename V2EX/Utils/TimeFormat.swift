//
//  TimeFormat.swift
//  V2EX
//
//  Created by Benjamin on 2022/10/21.
//

import Foundation

extension Date {
  
  func fromNow() -> String {
    // ask for the full relative date
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    formatter.locale = Locale.init(identifier: Locale.preferredLanguages.first!)

    // get exampleDate relative to the current date
    let relativeDate = formatter.localizedString(for: self, relativeTo: Date.now)

    return relativeDate
  }
  
}
