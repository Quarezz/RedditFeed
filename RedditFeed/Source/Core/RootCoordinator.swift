//
//  RootCoordinator.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

fileprivate let kStoryboardName = "Feed"
fileprivate let kRootNavigationName = "RootNavigationController"
fileprivate let kFeedVcName = "FeedViewController"
fileprivate let kImageVcName = "SourceImageViewController"

protocol FeedViewOutput: class {
    
    func navigateToImage(imageUrl: URL, animated: Bool)
}

class RootCoordinator: NSObject, FeedViewOutput {
    
    // MARK: Private variables
    
    private var storyboard = UIStoryboard(name: kStoryboardName, bundle: nil)
    private var rootNavigationController: RootNavigationController?
    
    // MARK: Public methods
    
    public func initialViewController() -> RootNavigationController? {
        
        if self.rootNavigationController != nil {
            return self.rootNavigationController
        }
        
        self.rootNavigationController = self.storyboard.instantiateViewController(withIdentifier: kRootNavigationName) as? RootNavigationController
        guard let feedVc = self.rootNavigationController?.viewControllers.first as? FeedViewController else {
            fatalError("Root navigation stack corrupted")
        }
        feedVc.output = self
        
        return self.rootNavigationController
    }
    
    public func restorationViewController(restorationIds: [String], fromStoryboard: UIStoryboard) -> UIViewController? {
        
        self.storyboard = fromStoryboard
        
        // Restoration stack count could be 2
        if restorationIds.count > 1 {
            
            switch restorationIds.last! {
                
            case kFeedVcName:
                
                let feed = self.storyboard.instantiateViewController(withIdentifier: kFeedVcName) as? FeedViewController
                feed?.output = self
                return feed
            case kImageVcName:
                
                let image = self.storyboard.instantiateViewController(withIdentifier: kImageVcName)
                return image
            default:
                return nil
            }
        }
        return nil
    }
    
    // MARK: FeedViewOutput
    
    func navigateToImage(imageUrl: URL, animated: Bool) {
        
        guard let imageVc = self.storyboard.instantiateViewController(withIdentifier: kImageVcName) as? SourceImageViewController else {
            fatalError("Unable to retreive SourceImageViewController")
        }
        imageVc.model = SourceImageModel(imageUrl: imageUrl)
        
        self.rootNavigationController?.pushViewController(imageVc, animated: animated)
    }
}
