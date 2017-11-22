//
//  PostItem.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

class PostItem: Decodable {

    // MARK: Declarations
    
    enum CodingKeys: String, CodingKey {
        case author
        case created_utc
        case title
        case thumbnail
        case num_comments
    }
    
    // MARK: Public variables
    
    public let author: String
    public let date: String
    public let text: String
    public let thumbnailUrl: URL?
    public let commentsCount: Int
    
    // MARK: Initialization
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.author = try values.decode(String.self, forKey: .author)
        self.text = try values.decode(String.self, forKey: .title)
        self.commentsCount = try values.decode(Int.self, forKey: .num_comments)
        
        let timestamp = try values.decode(String.self, forKey: .created_utc)
        self.date = timestamp.formattedDate(format: .redditPost)
        
        let thumbnail = try values.decode(String.self, forKey: .thumbnail)
        self.thumbnailUrl = URL(string: thumbnail)
    }
}
