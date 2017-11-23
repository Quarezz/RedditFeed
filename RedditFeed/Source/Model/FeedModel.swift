//
//  FeedModel.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

fileprivate let kFeedPageLimit: Int = 20

class FeedModel: NSObject {

    // MARK: Private variables
    
    private let feedService: RedditFeedServiceInterface
    
    // Any kind of cache could be used
    private var imageCacheService: [String: UIImage]
    
    private var imagesLoadingQueue: OperationQueue
    private var imagesAwaitCallback: ((URL, UIImage)->Void)?
    
    // MARK: Initialization
    
    init(feedService: RedditFeedServiceInterface = RedditFeedService()) {
        
        self.feedService = feedService
        self.imageCacheService = [String: UIImage]()
        self.imagesLoadingQueue = OperationQueue()
        self.imagesLoadingQueue.maxConcurrentOperationCount = 5
        super.init()
    }
    
    deinit {
        
        self.imagesLoadingQueue.cancelAllOperations()
        self.imagesAwaitCallback = nil
    }
    
    // MARK: Public methods
    
    public func fetchFeed(offset: Int, completion: @escaping FeedCompletion) {
        self.feedService.fetchFeed(limit: kFeedPageLimit, count: offset, result: { (result) in
            
            DispatchQueue.main.async {
                completion(result)
            }
        })
    }
    
    public func awaitForImageUpdates(callback: @escaping (URL,UIImage)->Void) {
        self.imagesAwaitCallback = callback
    }
    
    public func postImageWithUrl(url: URL) -> UIImage {
        
        if let image = self.imageCacheService[url.absoluteString] {
            return image
        }
        else {
            
            self.imagesLoadingQueue.addOperation {
                
                URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
                    
                    guard error == nil else {
                        print("error loading image: " + error!.localizedDescription)
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        self.imageCacheService[url.absoluteString] = image
                        
                        DispatchQueue.main.async {
                            self.imagesAwaitCallback?(url, image)
                        }
                    }
                }).resume()
            }
            
            return UIImage(named: "placeholder")!
        }
    }
}
