//
//  FeedViewController.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    // MARK: Private variables
    
    private let model = FeedModel()
    
    // MARK: Overriden
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.model.fetchFeed(offset: 0) { (_) in
            
        }
    }

}
