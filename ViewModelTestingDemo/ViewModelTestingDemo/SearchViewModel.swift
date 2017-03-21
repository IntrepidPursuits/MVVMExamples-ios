//
//  SearchViewControllerViewModel.swift
//  ViewModelTestingDemo
//
//  Created by Bryan Weber on 10/27/16.
//  Copyright © 2016 Bryan Weber. All rights reserved.
//

import Foundation
import Intrepid

class SearchViewModel {
    
    //Require mocking for testing
    private let networkingLayer: NetworkingLayer
    var persistenceLayer: PersistenceLayer = UserDefaults.standard
    
    var albumViewModels: [AlbumSearchResultCellViewModel] = []
    private let hasPreviouslyLoadedKey = "hasPreviouslyLoaded"
    
    var hasPreviouslyLoaded: Bool {
        return persistenceLayer.bool(forKey: hasPreviouslyLoadedKey)
    }
    
    init(networkingLayer: NetworkingLayer = NetworkingLayer()) {
        self.networkingLayer = networkingLayer
    }
    
    func albumViewModelAt(index: Int) -> AlbumSearchResultCellViewModel {
        return albumViewModels[index]
    }

    func searchFor(searchTerm: String, completionHandler:@escaping () -> ()) {
        networkingLayer.searchFor(searchTerm: searchTerm) { [weak self] (albums) in
            
            let unsortedViewModels = albums.map( {AlbumSearchResultCellViewModel(album: $0)} )
            let (currentViewModels, unsortedNonCurrentViewModels) = unsortedViewModels.ip_split(withFilter: { $0.isCurrent })
            let sortedNonCurrentViewModels = unsortedNonCurrentViewModels.sorted { $0.title < $1.title }
            self?.albumViewModels = currentViewModels + sortedNonCurrentViewModels
            
            completionHandler()
        }
    }
    
    func setHasPreviouslyLoaded(hasPreviouslyLoaded: Bool) {
        persistenceLayer.set(hasPreviouslyLoaded, forKey: hasPreviouslyLoadedKey)
    }
}

