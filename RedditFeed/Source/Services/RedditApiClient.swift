//
//  RedditApiClient.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit
import SafariServices

fileprivate let kRedditApiUrl = "https://www.reddit.com/top.json"

class RedditApiClient: NSObject {

    // MARK: Declarations
    
    enum RedditApiResult {
        case success(data: Data)
        case fail(reason: String)
    }
    
    // MARK: Public methods
    
    public func loadPosts(withOffset offset: Int, limit: Int, completion: @escaping (RedditApiResult) -> Void) {
        
        var authUrlString = kRedditApiUrl + "?limit=\(limit)&count=\(offset)"
        authUrlString = authUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        URLSession.shared.dataTask(with: URL(string: authUrlString)!) { (data, _, error) in
            
            guard error == nil, let data = data else {
                completion(.fail(reason: error?.localizedDescription ?? "no data"))
                return
            }
            completion(.success(data: data))
        }.resume()
    }
}
