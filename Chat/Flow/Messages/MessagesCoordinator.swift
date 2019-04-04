//
//  MessagesCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift

class MessagesCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let messagesViewModel = MessagesViewModel()
        let messagesViewController = MessagesTableViewController.create(with: messagesViewModel)
        navigationController.setViewControllers([messagesViewController], animated: false)
        
        return Observable.never()
    }
}
