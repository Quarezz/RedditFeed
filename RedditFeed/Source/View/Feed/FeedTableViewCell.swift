//
//  FeedTableViewCell.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

protocol FeedTableViewCellDelegate: class {
    
    func feedCellThumbnailTapped(cell: FeedTableViewCell)
}

class FeedTableViewCell: UITableViewCell {

    // MARK: Public variables
    
    public weak var delegate: FeedTableViewCellDelegate?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    
    // MARK: Overriden
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.thumbnailImageView.isUserInteractionEnabled = true
        self.thumbnailImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedTableViewCell.tappedThumbnail)))
    }
    
    // MARK: Public methods
    
    public func setData(_ data: PostItem) {
     
        self.authorLabel.text = data.author
        self.dateLabel.text = data.date
        self.postTitleLabel.text = data.text
        self.commentsLabel.text = NSLocalizedString("feed.post.comments", comment: "") + " \(data.commentsCount ?? 0)"
        self.thumbnailImageView.isHighlighted = (data.thumbnailUrl == nil)
    }
    
    public func updateThumbnail(image: UIImage) {
        self.thumbnailImageView.image = image
    }
    
    // MARK: Private methods
    
    @objc private func tappedThumbnail() {
        self.delegate?.feedCellThumbnailTapped(cell: self)
    }
}
