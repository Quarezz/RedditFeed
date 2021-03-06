//
//  RootCoordinatorTests.swift
//  RedditFeedTests
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import XCTest

@testable import RedditFeed

class RootCoordinatorTests: XCTestCase {
    
    func testInitialStack() {
        
        let rootCoordinator = RootCoordinator()
        let navigationVc = rootCoordinator.initialViewController()
        
        XCTAssertNotNil(navigationVc)
        XCTAssertEqual(navigationVc?.viewControllers.isEmpty, false, "Root Navigation stack can't be empty")
    }
    
    func testImageSourceNavigation() {
        
        let rootCoordinator = RootCoordinator()
        let navigationVc = rootCoordinator.initialViewController()
        let window = UIWindow()
        window.rootViewController = navigationVc
        window.makeKeyAndVisible()
        
        let url = URL(string: "google.com")!
        
        rootCoordinator.navigateToImage(imageUrl: url, animated: false)
        XCTAssertEqual(navigationVc?.viewControllers.count, 2)
    }
}
