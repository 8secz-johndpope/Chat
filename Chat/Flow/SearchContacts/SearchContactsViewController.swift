//
//  SearchContactsViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/16/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class SearchContactsViewController: UITableViewController {

    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    var searchBar: UISearchBar { return searchController.searchBar }
    
    var viewModel: SearchContactsViewModel!
    private var disposeBag = DisposeBag()
    private let cellIdentifier = R.reuseIdentifier.contactCell.identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureViewModel()
    }

    private func configureUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    private func configureViewModel() {
        viewModel.output.usersInfoObservable
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: UITableViewCell.self)) { (element, userInfo, cell) in
                cell.textLabel?.text = userInfo.username
                cell.imageView?.kf.setImage(with: URL(string: userInfo.imageUrl)!,
                                            placeholder: R.image.profile())
        }.disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .subscribe(viewModel.input.searchBarText)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(UserInfo.self)
            .bind(to: viewModel.input.selection)
            .disposed(by: disposeBag)
    }

}

extension SearchContactsViewController {
    
    static func create(with viewModel: SearchContactsViewModel) -> SearchContactsViewController {
        let viewController = R.storyboard.main.searchContactsViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
}
