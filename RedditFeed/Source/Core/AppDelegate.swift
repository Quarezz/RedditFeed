//
//  AppDelegate.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Public variables
    
    var window: UIWindow?
    
    // MARK: Private variables
    
    private let flowCoordinator = RootCoordinator()

    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
       
        if (NSClassFromString("XCTest") != nil) {
            return true
        }
        
        if (self.window == nil) {
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = self.flowCoordinator.initialViewController()
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        
        guard let identifiers = identifierComponents as? [String] else {
            return nil
        }
        
        if let storyboard = coder.decodeObject(forKey: UIStateRestorationViewControllerStoryboardKey) as? UIStoryboard {
            return self.flowCoordinator.restorationViewController(restorationIds: identifiers, fromStoryboard: storyboard)
        }
        return nil
    }
}

