//
//  SearchContactsViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/16/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit

class SearchContactsViewController: UITableViewController {

    var viewModel: SearchContactsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureViewModel()
    }

    private func configureUI() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func configureViewModel() {
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension SearchContactsViewController {
    
    static func create(with viewModel: SearchContactsViewModel) -> SearchContactsViewController {
        let viewController = R.storyboard.main.searchContactsViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
}

extension SearchContactsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}
