//
//  FeedModel.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

fileprivate let kFeedPageLimit: Int = 20

class FeedModel: NSObject {

    // MARK: Private variables
    
    private let feedService: RedditFeedServiceInterface
    
    // MARK: Initialization
    
    init(feedService: RedditFeedServiceInterface = RedditFeedService()) {
        
        self.feedService = feedService
        super.init()
    }
    
    // MARK: Public methods
    
    public func fetchFeed(offset: Int, completion: @escaping FeedCompletion) {
        self.feedService.fetchFeed(limit: kFeedPageLimit, count: offset, result: { (result) in
            
            DispatchQueue.main.async {
                completion(result)
            }
        })
    }
}
