//
//  MessagesViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class MessagesTableViewController: UITableViewController {
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    var searchBar: UISearchBar { return searchController.searchBar }

    var viewModel: MessagesViewModel!
    private let disposeBag = DisposeBag()
    private let cellIdentifier = R.reuseIdentifier.chatCell.identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureViewModel()
    }

    private func configureUI() {
        navigationController?.navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    private func configureViewModel() {
        viewModel.input.fetchChats.onNext(())
        
        viewModel.output.chatsObservable
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: ChatCell.self)) { (element, chat, cell) in
                let viewModel = ChatCellViewModel(with: chat)
                cell.bind(to: viewModel)
            }.disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .subscribe(viewModel.input.searchBarText)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Chat.self)
            .do(onNext: { [weak self] (_) in
                self?.showLoadingToast()
            })
            .bind(to: viewModel.input.selection)
            .disposed(by: disposeBag)
        
        viewModel.output
            .fetchCompanionObservable
            .subscribe(onNext: { [weak self] _ in
                self?.view.stopToast()
            }).disposed(by: disposeBag)
    }
    
    private func showLoadingToast() {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                        type: .circleStrokeSpin)
        activityIndicator.startAnimating()
        self.view.showToast(text: "loading...", view: activityIndicator)
    }
}

extension MessagesTableViewController {
    
    static func create(with viewModel: MessagesViewModel) -> MessagesTableViewController {
        let viewController = R.storyboard.main.messagesTableViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
