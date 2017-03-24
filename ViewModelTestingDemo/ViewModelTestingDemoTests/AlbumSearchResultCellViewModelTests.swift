//
//  AlbumSearchResultCellViewModelTests.swift
//  ViewModelTestingDemo
//
//  Created by Bryan Weber on 10/28/16.
//  Copyright © 2016 Bryan Weber. All rights reserved.
//

import XCTest
@testable import ViewModelTestingDemo

class AlbumSearchResultCellViewModelTests: XCTestCase {
        
    func testAlbumSearchResultCellViewModelProperties() {
        let releaseDate = Date(dateString: "2016-10-07T07:00:00Z")
        
        let album = Album(title: "Big Boat", artist: "Phish", releaseDate: releaseDate!, imageURL: URL(string: "http://www.google.com")!)
        let viewModel = AlbumSearchResultCellViewModel(album: album)

        XCTAssertEqual(viewModel.title, "Big Boat")
        XCTAssertEqual(viewModel.details, "Phish | 2016")
        XCTAssertEqual(viewModel.coverURL.absoluteString, "http://www.google.com")
    }
    
    func testAlbumSearchResultCellViewModelisCurrent() {
        let currentDate = Date()
        
        let currentAlbum = Album(title: "Big Boat", artist: "Phish", releaseDate: currentDate, imageURL: URL(string: "http://www.google.com")!)
        let currentAlbumViewModel = AlbumSearchResultCellViewModel(album: currentAlbum)
        
        XCTAssert(currentAlbumViewModel.isCurrent)
        
        let twentyYears = TimeInterval(60 * 60 * 24 * 365 * 20)
        let notCurrentDate = Date(timeIntervalSinceNow: -twentyYears)
        
        let notCurrentAlbum = Album(title: "Billy Breathes", artist: "Phish", releaseDate: notCurrentDate, imageURL: URL(string: "http://www.google.com")!)
        let notCurrentAlbumViewModel = AlbumSearchResultCellViewModel(album: notCurrentAlbum)
        
        XCTAssert(!notCurrentAlbumViewModel.isCurrent)
    }    
}
