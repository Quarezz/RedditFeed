//
//  SourceImageModelTests.swift
//  RedditFeedTests
//
//  Created by Ruslan Nikolaev on 23/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

import XCTest
import Photos

@testable import RedditFeed

class SourceImageModelTests: XCTestCase {
    
    let mockUrl = URL(string: "google.com")!
    
    func testImageFetchingSuccess() {
        
        let session = MockSession()
        session.shouldFail = false
        
        let model = SourceImageModel(imageUrl: mockUrl, loadSession: session)
        
        let expectation = self.expectation(description: "fetchSuccess")
        model.fetchImage { (image) in
            
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testImageFetchingError() {
        
        let session = MockSession()
        session.shouldFail = true
        
        let model = SourceImageModel(imageUrl: mockUrl, loadSession: session)
        
        let nilDataExpectation = self.expectation(description: "fetchErrorNilData")
        model.fetchImage { (image) in
            
            XCTAssertNil(image)
            nilDataExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        session.someError = true
        let errorExpectation = self.expectation(description: "fetchErrorWithError")
        model.fetchImage { (image) in
            
            XCTAssertNil(image)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    class MockSession: URLSession {
        
        var shouldFail = false
        var someError = false
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            if shouldFail {
                
                if someError {
                    completionHandler(nil, nil, NSError(domain: "", code: 0, userInfo: nil))
                }
                else {
                    completionHandler(nil,nil,nil)
                }
            }
            else {
                
                let data = try! Data(contentsOf: URL(fileURLWithPath: Bundle(for: SourceImageModelTests.self).path(forResource: "mock", ofType: "png")!))
                completionHandler(data, nil, nil)
            }
            return MockTask()
        }
    }
    
    class MockTask: URLSessionDataTask {
        
        override func resume() {
            
        }
    }
}
