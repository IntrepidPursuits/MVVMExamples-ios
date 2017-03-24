//
//  AlbumSearchResultCellViewModel.swift
//  ViewModelTestingDemo
//
//  Created by Bryan Weber on 10/27/16.
//  Copyright © 2016 Bryan Weber. All rights reserved.
//

import Foundation

class AlbumSearchResultCellViewModel {
    
    private let album: Album
    
    var title: String {
        return album.title
    }
    
    var details: String {
        return "\(album.artist) | \(releaseYear)"
    }
    
    var coverURL: URL {
        return album.imageURL
    }
    
    var isCurrent: Bool {
        let calendar = Calendar(identifier: .gregorian)
        
        let dateComponents = calendar.dateComponents([.year], from: Date())
        let currentYear = String(dateComponents.year!)
        
        return currentYear == releaseYear
    }
    
    private var releaseYear: String {
        let calendar = Calendar(identifier: .gregorian)
        
        let dateComponents = calendar.dateComponents([.year], from: album.releaseDate)
        return String(dateComponents.year!)
    }
    
    init(album: Album) {
        self.album = album
    }
}
