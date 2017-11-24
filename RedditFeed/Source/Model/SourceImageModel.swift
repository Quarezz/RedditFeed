//
//  SourceImageModel.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 23/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit
import Photos

class SourceImageModel: NSObject, NSCoding {

    // MARK: Private variables

    // Additional apiClient or imageService(cache+network) can go here
    private let loadSession: URLSession
    
    private let imageUrl: URL
    
    // MARK: Initialization
    
    init(imageUrl: URL,
         loadSession: URLSession = URLSession.shared) {
        
        self.imageUrl = imageUrl
        self.loadSession = loadSession
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        guard let url = URL(string: aDecoder.decodeObject(forKey: "imagemodel.url") as? String ?? "") else {
            return nil
        }
        self.imageUrl = url
        self.loadSession = URLSession.shared
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.imageUrl.absoluteString, forKey: "imagemodel.url")
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
            else if let data = data, let image = UIImage(data: data) {
                
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
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch status {
            case .authorized:
                
                PHPhotoLibrary.shared().performChanges({
                    
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                    
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
