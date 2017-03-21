//
//  SearchViewController.swift
//  ViewModelTestingDemo
//
//  Created by Bryan Weber on 10/25/16.
//  Copyright © 2016 Bryan Weber. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !viewModel.hasPreviouslyLoaded {
            showPopup()
            viewModel.setHasPreviouslyLoaded(hasPreviouslyLoaded: true)
        }
    }
    
    func showPopup() {
        let alert = UIAlertController(title: "Hello", message: "Upgrade Your Account", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: UISearchBarDelegate
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text else { return }
        
        viewModel.searchFor(searchTerm: searchTerm) { [weak self] in
            DispatchQueue.main.sync {
                self?.tableView.reloadData()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albumViewModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumSearchResultCell", for: indexPath) as! AlbumSearchResultTableViewCell
        let albumViewModels = viewModel.albumViewModelAt(index: indexPath.row)
        cell.titleLabel.text = albumViewModels.title
        cell.detailsLabel.text = albumViewModels.details
        cell.coverImageView.af_setImage(withURL: albumViewModels.coverURL)
        return cell
    }
}
