//
//  ContactResultsTableController.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/12/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContactResultsTableController: UITableViewController {

    var viewModel: ContactResultsViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureViewModel()
    }
    
    private func configureUI() {
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = nil
        tableView.delegate = nil
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
    }
}

extension ContactResultsTableController {
    
    static func create(with viewModel: ContactResultsViewModel) -> ContactResultsTableController {
        let viewController = ContactResultsTableController()
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
