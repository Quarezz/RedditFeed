//
//  RedditFeedServiceInterface.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import Foundation

enum FeedFetchResult {
    case success(feed: [PostItem])
    case fail(reason: String)
}

typealias FeedCompletion = (_ result: FeedFetchResult) -> Void

protocol RedditFeedServiceInterface {
    
    /// Fetch reddit feed
    /// - parameter limit: the maximum number of items to return in this slice of the listing
    /// - parameter count: the number of items already seen in this listing
    /// - parameter result: completion block with result state
    func fetchFeed(limit: Int, count: Int, result: @escaping FeedCompletion)
}
