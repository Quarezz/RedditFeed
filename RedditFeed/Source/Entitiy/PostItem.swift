//
//  PostItem.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

struct PostItem {
    
    // MARK: Public variables
    
    public let author: String
    public let date: String
    public let text: String
    public let thumbnailUrl: URL?
    public let commentsCount: Int?
    
    // MARK: Initialization
    
    init?(json: [String: Any]) {
        
        guard let author = json["author"] as? String            else { return nil }
        guard let text = json["title"] as? String               else { return nil }
        
        self.author = author
        self.text = text
        
        let timestamp = json["created_utc"] as? String ?? ""
        self.date = timestamp.formattedDate(format: .redditPost)
        
        let thumbnail = URL(string: json["thumbnail"] as? String ?? "")
        if thumbnail?.host != nil {
            self.thumbnailUrl = thumbnail
        }
        else {
            self.thumbnailUrl = nil
        }
        
        self.commentsCount = json["num_comments"] as? Int
    }
}
