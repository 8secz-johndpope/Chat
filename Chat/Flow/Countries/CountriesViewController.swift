//
//  CountriesViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

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
    private let cellIdentifier = R.reuseIdentifier.countryCell.identifier
    
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
    }
    
    private func configureViewModel() {
        backButton.rx.tap
            .subscribe(viewModel.input.backButtonDidTap)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { [weak self] dataSource, tableView, indexPath, country in
                guard let self = self, let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CountryCell else {
                        return UITableViewCell()
                }
                
                let viewModel = CountryCellViewModel(country: country)
                cell.bind(to: viewModel)
                return cell
            },
            titleForHeaderInSection: { (countries, index) -> String in
                return countries[index].header
            }
        )
        
        dataSource.sectionIndexTitles = { [weak self] section in
            guard let self = self else { return nil}
            return [UITableView.indexSearch] + self.viewModel.output.sections.value.map { $0.header }
        }
        
        dataSource.sectionForSectionIndexTitle = { (section, title, index) in
            return index == 0 ? 0 : index - 1
        }
        
        viewModel.output
            .sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .subscribe(viewModel.input.searchBarText)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Country.self)
            .bind(to: viewModel.input.selection)
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
