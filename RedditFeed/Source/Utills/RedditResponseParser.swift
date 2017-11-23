//
//  RedditResponseMapper.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 23/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

class RedditResponseParser: NSObject {

    // MARK: Public methods
    
    public func parse(data: Data) -> [PostItem]? {

        guard let root = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            return nil
        }
        guard let json = root as? [String: Any] else {
            return nil
        }
        
        guard let dataJson = json["data"] as? [String: Any] else {
            return nil
        }
        
        guard let childrenJsonArray = dataJson["children"] as? [[String: Any]] else {
            return nil
        }
        
        let dataJsonArray = childrenJsonArray.map({$0["data"] as? [String: Any]}).flatMap({$0})
        
        guard !dataJsonArray.isEmpty else {
            return nil
        }
        
        let items = dataJsonArray.map({ PostItem(json: $0) }).flatMap({$0})
        return items
    }
}
