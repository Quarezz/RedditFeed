//
//  FeedServiceTests.swift
//  RedditFeedTests
//
//  Created by Ruslan Nikolaev on 22/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import XCTest

@testable import RedditFeed

class FeedServiceTests: XCTestCase {
    
    func testApiError() {
        
        let mockApi = MockApiClient()
        mockApi.shouldFail = true
        let service = RedditFeedService(apiClient: mockApi)
        
        service.fetchFeed(limit: 0, count: 0) { (result) in
            
            switch result {
            case .success(_):
                XCTAssert(false)
                break
            case .fail(_):
                XCTAssert(true)
                break
            }
        }
    }
    
    func testParsingError() {
        
        let mockApi = MockApiClient()
        mockApi.shouldFail = false
        
        let mockParser = MockParser()
        mockParser.shouldFail = true
        let service = RedditFeedService(apiClient: mockApi, responseParser: mockParser)
        
        service.fetchFeed(limit: 0, count: 0) { (result) in
            
            switch result {
            case .success(_):
                XCTAssert(false)
                break
            case .fail(_):
                XCTAssert(true)
                break
            }
        }
    }
    
    func testSuccess() {
        
        let mockApi = MockApiClient()
        mockApi.shouldFail = false
        let mockParser = MockParser()
        mockParser.shouldFail = false
        let service = RedditFeedService(apiClient: mockApi, responseParser: mockParser)
        
        service.fetchFeed(limit: 0, count: 0) { (result) in
            
            switch result {
            case .success(_):
                XCTAssert(true)
                break
            case .fail(_):
                XCTAssert(false)
                break
            }
        }
    }
    
    class MockApiClient: RedditApiClient {
        
        var shouldFail = false
        
        override func loadPosts(withOffset offset: Int, limit: Int, completion: @escaping (RedditApiClient.RedditApiResult) -> Void) {
            
            if shouldFail {
                completion(.fail(reason: ""))
            }
            else {
                completion(.success(data: Data()))
            }
        }
    }
    
    class MockParser: RedditResponseParser {
        
        var shouldFail = false
        
        override func parse(data: Data) -> [PostItem]? {
            return shouldFail ? nil : [PostItem]()
        }
    }
}
