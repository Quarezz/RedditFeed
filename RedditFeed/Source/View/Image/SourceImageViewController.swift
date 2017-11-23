//
//  SourceImageViewController.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 23/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

class SourceImageViewController: UIViewController {

    // MARK: Public variables
    
    public var model: SourceImageModel?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: Overriden
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.model?.fetchImage(completion: {[weak self] (image) in
            
            self?.activityIndicator.stopAnimating()
            self?.imageView.image = image
            
            if image == nil {
                self?.showError(message: NSLocalizedString("image.loading.error", comment: ""))
            }
            else {
                self?.saveButton.isEnabled = true
            }
        })
    }
    
    // MARK: Private methods
    
    private func showError(message: String) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("common.ok", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    
    @IBAction func tappedBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSaveImage(_ sender: Any) {
        
        guard let image = self.imageView.image else {
            return
        }
        
        self.model?.saveImageToGallery(image: image, completion: {[weak self] (error) in
            
            if let error = error {
                self?.showError(message: error)
            }
        })
    }
}
