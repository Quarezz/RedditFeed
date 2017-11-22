//
//  RedditFeedService.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

class RedditFeedService: NSObject, RedditFeedServiceInterface {

    // MARK: Private variables
    
    private let apiClient: RedditApiClient
    private let responseParser: RedditResponseParser
    
    // MARK: Initialization
    
    init(apiClient: RedditApiClient = RedditApiClient(),
         responseParser: RedditResponseParser = RedditResponseParser()) {
        
        self.apiClient = apiClient
        self.responseParser = responseParser
    }
    
    // MARK: RedditFeedServiceInterface
    
    func fetchFeed(limit: Int, count: Int, result: @escaping FeedCompletion) {
        
        self.apiClient.loadPosts(withOffset: count, limit: limit) {[weak self] (apiResult) in
            
            switch apiResult {
            case .fail(let reason):
                result(.fail(reason: reason))
                break
            case .success(let data):
                
                guard let items = self?.responseParser.parse(data: data) else {
                    
                    result(.fail(reason: "data inconsistency"))
                    return
                }
                result(.success(feed: items))
                break
            }
        }
    }
}
