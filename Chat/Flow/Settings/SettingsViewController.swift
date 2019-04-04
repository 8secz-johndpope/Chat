//
//  SettingsViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var viewModel: SettingsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension SettingsViewController {
    
    static func create(with viewModel: SettingsViewModel) -> SettingsViewController {
        let viewController = R.storyboard.main.settingsViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
