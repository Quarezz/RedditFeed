//
//  FeedLoadMoreFooter.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 23/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

class FeedLoadMoreFooter: UITableViewHeaderFooterView {

    // MARK: Private variables
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    // MARK: Initialization
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    // MARK: Overriden
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.activityIndicator.startAnimating()
        
        let indicatorSize = self.activityIndicator.bounds.width
        self.activityIndicator.frame = CGRect(x: self.bounds.width/2 - indicatorSize/2,
                                              y: self.bounds.height/2 - indicatorSize/2,
                                              width: indicatorSize,
                                              height: indicatorSize)
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        
        self.addSubview(self.activityIndicator)
    }
}
