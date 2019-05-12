//
//  ContactsTableViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class ContactsTableViewController: UITableViewController {
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchBar.placeholder = "Search contacts"
        searchController.searchResultsUpdater = self
        
        return searchController
    }()
    
    var searchBar: UISearchBar { return searchController.searchBar }
    
    var viewModel: ContactsViewModel!
    var resultsViewModel = ContactResultsViewModel()
    lazy var resultsTableController = ContactResultsTableController.create(with: resultsViewModel)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureViewModel()
    }
    
    private func configureUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
    }

    private func configureViewModel() {
        viewModel.output.contacts
            .drive(tableView.rx.items(cellIdentifier: ContactCell.identifier, cellType: ContactCell.self)) { (element, userInfo, cell) in
                let viewModel = ContactCellViewModel(contact: userInfo)
                cell.bind(to: viewModel)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(UserInfo.self)
            .bind(to: viewModel.input.selection)
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .subscribe(resultsViewModel.input.searchBarText)
            .disposed(by: disposeBag)
    }
    
}

extension ContactsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        resultsViewModel.clearPreviousResults()
    }
    
}

extension ContactsTableViewController {
    
    static func create(with viewModel: ContactsViewModel) -> ContactsTableViewController {
        let viewController = R.storyboard.main.contactsTableViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
