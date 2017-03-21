//
//  MockNetworkingLayer.swift
//  ViewModelTestingDemo
//
//  Created by Bryan Weber on 11/1/16.
//  Copyright © 2016 Bryan Weber. All rights reserved.
//

import Foundation
@testable import ViewModelTestingDemo

class MockNetworkingLayer: NetworkingLayer {
    
    let mockSearchResults: [Album]
    
    init(searchResults: [Album]) {
        mockSearchResults = searchResults
    }
    
    override func searchFor(searchTerm: String, completionHandler:@escaping ([Album]) -> ()) {
        completionHandler(mockSearchResults)
    }
    
}
