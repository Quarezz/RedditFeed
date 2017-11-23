//
//  SourceImageModel.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 23/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit
import Photos

class SourceImageModel: NSObject {

    // MARK: Private variables

    private let loadSession: URLSession
    private let imageUrl: URL
    private let photoLibraryClass: PHPhotoLibrary.Type
    private let assetChangeRequestClass: PHAssetChangeRequest.Type
    
    // MARK: Initialization
    
    init(imageUrl: URL,
         loadSession: URLSession = URLSession.shared,
         photosLib: PHPhotoLibrary.Type = PHPhotoLibrary.self,
         assetChangeRequestClass: PHAssetChangeRequest.Type = PHAssetChangeRequest.self) {
        
        self.imageUrl = imageUrl
        self.loadSession = loadSession
        self.photoLibraryClass = photosLib
        self.assetChangeRequestClass = assetChangeRequestClass
    }
    
    // MARK: Public methods
    
    public func fetchImage(completion: @escaping (UIImage?)->Void) {
        
        self.loadSession.dataTask(with: self.imageUrl, completionHandler: { (data, _, error) in
            
            if let error = error {
                
                print("error loading source image: " + error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            if let data = data, let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            else {
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }).resume()
    }
    
    public func saveImageToGallery(image: UIImage, completion: @escaping (_ error: String?)->Void) {
        
        self.photoLibraryClass.requestAuthorization {[weak self] (status) in
            
            switch status {
            case .authorized:
                
                self?.photoLibraryClass.shared().performChanges({
                    
                    self?.assetChangeRequestClass.creationRequestForAsset(from: image)
                    
                }, completionHandler: { (result, error) in
                    
                    if let error = error {
                        completion(error.localizedDescription)
                    }
                    else if result == false {
                        completion(NSLocalizedString("image.save.error.access", comment: ""))
                    }
                    else {
                        completion(nil)
                    }
                })
                
            default:
                completion(NSLocalizedString("image.save.error.access", comment: ""))
                break
            }
        }
    }
}
