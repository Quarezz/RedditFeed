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
        self.fetchImage()
    }
    
    // MARK: Private methods
    
    private func fetchImage() {
        
        self.model?.fetchImage(completion: {[weak self] (image) in
            
            self?.activityIndicator.stopAnimating()
            self?.imageView.image = image
            
            if image == nil {
                self?.showAlert(message: NSLocalizedString("image.loading.error", comment: ""))
            }
            else {
                self?.saveButton.isEnabled = true
            }
        })
    }
    
    private func showAlert(message: String) {
        
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
                self?.showAlert(message: error)
            }
            else {
                self?.showAlert(message: NSLocalizedString("image.save.success", comment: ""))
            }
        })
    }
    
    // MARK: Restoration
    
    override func encodeRestorableState(with coder: NSCoder) {
        
        coder.encode(self.model, forKey: "imagevc.model")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        
        self.model = coder.decodeObject(forKey: "imagevc.model") as? SourceImageModel
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        
        super.applicationFinishedRestoringState()
        self.fetchImage()
    }
}
