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
    public let sourceImageUrl: URL?
    
    // MARK: Initialization
    
    init?(json: [String: Any]) {
        
        guard let author = json["author"] as? String            else { return nil }
        guard let text = json["title"] as? String               else { return nil }
        
        self.author = author
        self.text = text
        
        if let timestamp = json["created_utc"] as? Int {
            self.date = timestamp.formattedDate(format: .redditPost)
        }
        else {
            self.date = ""
        }
        
        let thumbnail = URL(string: json["thumbnail"] as? String ?? "")
        if thumbnail?.host != nil {
            self.thumbnailUrl = thumbnail
        }
        else {
            self.thumbnailUrl = nil
        }
        
        if let preview = json["preview"] as? [String: Any],
            let images = preview["images"] as? [[String: Any]],
            let source = images.first?["source"] as? [String: Any],
            let url = source["url"] as? String {
            
            self.sourceImageUrl = URL(string: url)
        }
        else {
            self.sourceImageUrl = nil
        }
        
        self.commentsCount = json["num_comments"] as? Int
    }
}
