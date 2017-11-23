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
fileprivate let kImageVcName = "SourceImageViewController"

protocol FeedViewOutput: class {
    
    func navigateToImage(imageUrl: URL)
}

class RootCoordinator: NSObject, FeedViewOutput {
    
    // MARK: Private variables
    
    private let storyboard = UIStoryboard(name: kStoryboardName, bundle: nil)
    private let rootNavigationController = UINavigationController()
    
    // MARK: Public methods
    
    public func initialViewController() -> UINavigationController? {
        
        let feedVc = self.storyboard.instantiateViewController(withIdentifier: kFeedVcName) as! FeedViewController
        feedVc.output = self
        self.rootNavigationController.viewControllers = [feedVc]
        return self.rootNavigationController
    }
    
    // MARK: FeedViewOutput
    
    func navigateToImage(imageUrl: URL) {
        
        let imageVc = self.storyboard.instantiateViewController(withIdentifier: kImageVcName) as! SourceImageViewController
        imageVc.model = SourceImageModel(imageUrl: imageUrl)
        
        let navigationController = UINavigationController(rootViewController: imageVc)
        navigationController.modalTransitionStyle = .crossDissolve
        
        self.rootNavigationController.present(navigationController, animated: true, completion: nil)
    }
}
