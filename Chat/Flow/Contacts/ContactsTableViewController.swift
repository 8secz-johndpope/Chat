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

    @IBOutlet var addContactButton: UIBarButtonItem!
    
    var viewModel: ContactsViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureViewModel()
    }
    
    private func configureUI() {
        tableView.tableFooterView = UIView()
    }

    private func configureViewModel() {
        addContactButton.rx.tap
            .subscribe(viewModel.input.addContactButtonDidTap)
            .disposed(by: disposeBag)
    }
    
}

extension ContactsTableViewController {
    
    static func create(with viewModel: ContactsViewModel) -> ContactsTableViewController {
        let viewController = R.storyboard.main.contactsTableViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
