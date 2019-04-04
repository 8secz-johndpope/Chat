//
//  ContactsCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift

class ContactsCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let contactsViewModel = ContactsViewModel()
        let contactsViewController = ContactsViewController.create(with: contactsViewModel)
        navigationController.setViewControllers([contactsViewController], animated: false)
        
        return Observable.never()
    }
}
