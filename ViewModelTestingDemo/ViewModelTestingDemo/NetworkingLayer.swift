//
//  NetworkingLayer.swift
//  ViewModelTestingDemo
//
//  Created by Bryan Weber on 10/26/16.
//  Copyright © 2016 Bryan Weber. All rights reserved.
//

import Foundation

class NetworkingLayer {
    
    let baseSearchURLString = "https://itunes.apple.com/search?"
    
    func searchFor(searchTerm: String, completionHandler:@escaping ([Album]) -> ()) {
        
        let url = URL(string: searchStringFor(searchTerm: searchTerm))
        let request = URLRequest(url: url!)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                guard
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let albumsDictionary = json?["results"] as? [[String: Any]]
                    else {
                        completionHandler([])
                        return
                    }
                
                var albums: [Album] = []
                
                albumsDictionary.forEach({ (albumDictionary) in
                    guard let album = self.albumFrom(dictionary: albumDictionary) else { return }
                    
                    albums.append(album)
                })
                
                completionHandler(albums)
            }
        })
        task.resume()
    }
    
    private func searchStringFor(searchTerm: String) -> String {
        let searchTermWhitespaceRemoved = searchTerm.replacingOccurrences(of: " ", with: "+")
        return baseSearchURLString + "term=" + searchTermWhitespaceRemoved + "&entity=album"
    }
    
    private func albumFrom(dictionary: [String: Any]) -> Album? {
        guard
            let title = dictionary["collectionName"] as? String,
            let artist =  dictionary["artistName"] as? String,
            let releaseDateString =  dictionary["releaseDate"] as? String,
            let releaseDate = Date(dateString: releaseDateString),
            let image =  dictionary["artworkUrl60"] as? String,
            let imageURL = URL(string: image)
            else { return nil }
        
        return Album(title: title, artist: artist, releaseDate: releaseDate, imageURL:imageURL)
    }
}
