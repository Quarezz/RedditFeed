//
//  FeedViewController.swift
//  RedditFeed
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FeedTableViewCellDelegate {

    // MARK: Public variables
    
    public weak var output: FeedViewOutput?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var dummyActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Private variables
    
    private let model = FeedModel()
    private var feed = [PostItem]()
    private var loadMoreAvailable = true
    
    // MARK: Overriden
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupRefreshControl()
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if self.feed.isEmpty {
            
            self.model.awaitForImageUpdates(callback: {[weak self] (url, image) in
                
                guard let strongSelf = self else { return }
                guard let index = strongSelf.feed.index(where: {$0.thumbnailUrl == url}) else { return }
                guard let indexPath = strongSelf.tableView.indexPathsForVisibleRows?.filter({$0.row == index}).first else { return }
                guard let cell = strongSelf.tableView.cellForRow(at: indexPath) as? FeedTableViewCell else { return }
                cell.updateThumbnail(image: image)
            })
            self.refreshFeed()
        }
    }
    
    // MARK: Private methods
    
    private func setupRefreshControl() {
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(FeedViewController.refreshFeed), for: .valueChanged)
    }
    
    private func setupTableView() {
        self.tableView.register(FeedLoadMoreFooter.self, forHeaderFooterViewReuseIdentifier: "FeedLoadMoreFooter")
    }
    
    @objc private func refreshFeed() {
        
        self.model.fetchFeed(offset: 0) {[weak self] (result) in
            
            self?.dummyActivityIndicator.stopAnimating()
            self?.tableView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let feed):
                
                self?.feed = feed
                self?.tableView.reloadData()
                break
            case .fail(let reason):
        
                self?.showError(message: reason)
                break
            }
        }
    }
    
    private func loadMore() {
        
        self.model.fetchFeed(offset: self.feed.count) {[weak self] (result) in
            
            switch result {
            case .success(let feed):
                
                self?.feed.append(contentsOf: feed)
                self?.tableView.reloadData()
                break
            case .fail(let reason):
                
                self?.showError(message: reason)
                break
            }
        }
    }
    
    private func showError(message: String) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("common.ok", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        if view is FeedLoadMoreFooter {
            self.loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? FeedTableViewCell {
            
            let post = self.feed[indexPath.row]
            if let url = post.thumbnailUrl {
                cell.updateThumbnail(image: self.model.postImageWithUrl(url: url))
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if self.feed.isEmpty == false && self.loadMoreAvailable {
            return 44
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if self.feed.isEmpty == false && self.loadMoreAvailable {
            
            guard let footer = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "FeedLoadMoreFooter") as? FeedLoadMoreFooter else {
                fatalError("FeedLoadMoreFooter not registered")
            }
            return footer
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as? FeedTableViewCell else {
            fatalError("FeedTableViewCell not registered")
        }
        
        cell.setData(self.feed[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    // MARK: FeedTableViewCellDelegate
    
    func feedCellThumbnailTapped(cell: FeedTableViewCell) {
        
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        guard let imageUrl = self.feed[indexPath.row].sourceImageUrl else {
            return
        }
        
        self.output?.navigateToImage(imageUrl: imageUrl, animated: true)
    }
    
    // MARK: Orientation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        self.tableView.reloadData()
    }
}
