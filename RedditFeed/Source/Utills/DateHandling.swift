//
//  DateHandling.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import Foundation

public enum DateFormats {
    case redditPost
}

extension Int {
    
    public func formattedDate(format: DateFormats) -> String {
        
        switch format {
        case .redditPost:
            
            let date = Date(timeIntervalSince1970: TimeInterval(self))
            let components = Calendar.current.dateComponents([.hour,.minute,.second], from: date, to: Date())
            
            if let hours = components.hour, hours > 0 {
                return "\(hours) hours ago"
            }
            if let minutes = components.minute, minutes > 0 {
                return "\(minutes) minutes ago"
            }
            if let seconds = components.second, seconds > 0 {
                return "\(seconds) seconds ago"
            }
            return ""
        }
    }
}
