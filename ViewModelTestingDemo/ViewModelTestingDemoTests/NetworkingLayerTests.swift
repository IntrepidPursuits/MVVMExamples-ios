//
//  NetworkingLayerTests.swift
//  ViewModelTestingDemo
//
//  Created by Bryan Weber on 10/27/16.
//  Copyright © 2016 Bryan Weber. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import ViewModelTestingDemo

class NetworkingLayerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCleanAlbumSearchResult() {
        
        stub(condition: isMethodGET()) { _ in
            let filePath = OHPathForFile("CleanAlbumSearch.json", self.classForCoder)
            return OHHTTPStubsResponse(fileAtPath: filePath!,
                                       statusCode: 200,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        let networkLayer = NetworkingLayer()
        
        let albumSearchExpectation = expectation(description: "CleanAlbumSearchResult")
        
        networkLayer.searchFor(searchTerm: "Phish") { albums in
            XCTAssert(albums.count == 3)
            
            let album = albums.first
            XCTAssertEqual(album?.title, "Big Boat")
            XCTAssertEqual(album?.artist, "Phish")
            XCTAssertEqual(album?.imageURL.absoluteString, "http://is1.mzstatic.com/image/thumb/Music71/v4/b1/f2/ae/b1f2ae1a-4f9f-5d5c-e5d5-a5eff1557059/source/60x60bb.jpg")
            albumSearchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 100) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                XCTFail()
            }
        }
    }

    func testMalformedAlbumSearchResult() {
        
        stub(condition: isMethodGET()) { _ in
            let filePath = OHPathForFile("MalformedAlbumSearch.json", self.classForCoder)
            return OHHTTPStubsResponse(fileAtPath: filePath!,
                                       statusCode: 200,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        let networkLayer = NetworkingLayer()
        
        let albumSearchExpectation = expectation(description: "MalformedAlbumSearchResult")
        
        networkLayer.searchFor(searchTerm: "Phish") { albums in
            XCTAssert(albums.count == 0)
            albumSearchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 100) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                XCTFail()
            }
        }
    }
    
    func testDeficientAlbumSearchResult() {
        
        stub(condition: isMethodGET()) { _ in
            let filePath = OHPathForFile("DeficientAlbumSearch.json", self.classForCoder)
            return OHHTTPStubsResponse(fileAtPath: filePath!,
                                       statusCode: 200,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        let networkLayer = NetworkingLayer()
        
        let albumSearchExpectation = expectation(description: "deficientAlbumSearchResult")
        
        networkLayer.searchFor(searchTerm: "Phish") { albums in
            XCTAssert(albums.count == 2)
            
            let firstAlbum = albums.first
            XCTAssertEqual(firstAlbum?.title, "Big Boat")
            
            let lastAlbum = albums.last
            XCTAssertEqual(lastAlbum?.title, "Farmhouse")
            
            albumSearchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 100) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                XCTFail()
            }
        }
    }
}
