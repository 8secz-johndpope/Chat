//
//  SettingsCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift

class SettingsCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let settingsViewModel = SettingsViewModel()
        let settingsViewController = SettingsViewController.create(with: settingsViewModel)
        navigationController.setViewControllers([settingsViewController], animated: false)
        
        return Observable.never()
    }
}
