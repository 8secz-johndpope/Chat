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
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = MainTabBarViewModel()
        let tabBarController = MainTabBarController.create(with: viewModel)
        
        let contactsNavigationController = UINavigationController()
        let messagesNavigationController = UINavigationController()
        let settingsNavigationController = UINavigationController()
        
        tabBarController.setViewControllers([contactsNavigationController,
                                             messagesNavigationController,
                                             settingsNavigationController],
                                            animated: false)
        window.rootViewController = tabBarController
        
        return Observable.merge(showChats(on: messagesNavigationController),
                                showSettings(on: settingsNavigationController),
                                showContacts(on: contactsNavigationController))
            .take(1)
            .do(onNext: { (_) in
                tabBarController.dismiss(animated: true, completion: nil)
            })
    }

    private func showContacts(on navigationController: UINavigationController) -> Observable<Void> {
        let contactsCoordinator = ContactsCoordinator(navigationController: navigationController)
        return coordinate(to: contactsCoordinator)
    }
    
    private func showChats(on navigationController: UINavigationController) -> Observable<Void> {
        let messagesCoordinator = MessagesCoordinator(navigationController: navigationController)
        return coordinate(to: messagesCoordinator)
    }
    
    private func showSettings(on navigationController: UINavigationController) -> Observable<Void> {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        return coordinate(to: settingsCoordinator)
    }
}
