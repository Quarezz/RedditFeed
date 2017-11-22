//
//  RootCoordinator.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

fileprivate let kStoryboardName = "Feed"
fileprivate let kFeedVcName = "FeedViewController"

class RootCoordinator: NSObject {
    
    // MARK: Public methods
    
    public func initialViewController() -> UINavigationController? {
        
        let storyboard = UIStoryboard(name: kStoryboardName, bundle: nil)
        let feedVc = storyboard.instantiateViewController(withIdentifier: kFeedVcName) as! FeedViewController
        
        let navigationVc = UINavigationController(rootViewController: feedVc)
        return navigationVc
    }
}
