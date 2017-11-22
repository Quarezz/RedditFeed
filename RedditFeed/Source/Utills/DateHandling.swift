//
//  DateHandling.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import Foundation

public enum DateFormats: String {
    case redditPost = ""
}

extension String {
    
    public func formattedDate(format: DateFormats) -> String {
        
        switch format {
        case .redditPost:
            
            let formatter = DateFormatter()
            return formatter.string(from: Date())
        }
    }
}
