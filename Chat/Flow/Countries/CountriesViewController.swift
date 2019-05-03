//
//  CountriesViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class CountriesViewController: UIViewController {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    var searchBar: UISearchBar { return searchController.searchBar }

    var viewModel: CountriesViewModel!
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
    }
    
    private func configureViewModel() {
        backButton.rx.tap
            .subscribe(viewModel.input.backButtonDidTap)
            .disposed(by: disposeBag)
    }

}

extension CountriesViewController {
    
    static func create(with viewModel: CountriesViewModel) -> CountriesViewController {
        let viewController = R.storyboard.auth.countriesViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
