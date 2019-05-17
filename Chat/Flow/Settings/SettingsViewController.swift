//
//  SettingsViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class SettingsTableViewController: UITableViewController {

    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var profileHeaderView: ProfileHeaderView!
    
    var viewModel: SettingsViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureViewModel()
    }
    
    private func configureUI() {

    }

    private func configureViewModel() {
        logoutButton.rx.tap
            .subscribe(viewModel.input.logoutButtonDidTap)
            .disposed(by: disposeBag)
    }
}

extension SettingsTableViewController {
    
    static func create(with viewModel: SettingsViewModel) -> SettingsTableViewController {
        let viewController = R.storyboard.main.settingsTableViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
