//
//  MainCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/30/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

final class MainTabBarCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let tabBarController = MainTabBarController.create()
        navigationController.present(tabBarController, animated: true)
        
        let contactsNavigationController = UINavigationController()
        let messagesNavigationController = UINavigationController()
        let settingsNavigationController = UINavigationController()
        
        tabBarController.setViewControllers([contactsNavigationController, messagesNavigationController, settingsNavigationController], animated: false)
        
        let contactsCoordinator = ContactsCoordinator(navigationController: contactsNavigationController)
        let messagesCoordinator = MessagesCoordinator(navigationController: messagesNavigationController)
        let settingsCoordinator = SettingsCoordinator(navigationController: settingsNavigationController)
        
        return coordinate(to: contactsCoordinator)
            .concat(coordinate(to: messagesCoordinator))
            .concat(coordinate(to: settingsCoordinator))
    }

}
