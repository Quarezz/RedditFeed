//
//  PostItem.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

class PostItem: NSObject {

    // MARK: Public variables
    
    public let author: String
    public let date: String
    public let text: String
    public let thumbnailUrl: URL?
    public let commentsCount: Int
    
    // MARK: Initialization
    
    init?(json: [String: Any]) {
        
        self.author = json["author"] as? String ?? ""
        let date = json["date"] as? String ?? ""
        self.date = date.formattedDate(format: .redditPost)
        
        self.text = json["text"] as? String ?? ""
        self.thumbnailUrl = URL(string: json["url"] as? String ?? "")
        self.commentsCount = json["commentsCount"] as? Int ?? 0
        
        super.init()
    }
}
