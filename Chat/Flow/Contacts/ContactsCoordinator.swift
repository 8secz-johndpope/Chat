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
        let contactsViewController = ContactsTableViewController.create(with: contactsViewModel)
        navigationController.setViewControllers([contactsViewController], animated: false)
        
        contactsViewModel.output.addContactButtonObservable
            .flatMap({ [weak self] _ -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.showSearchContacts(on: self.navigationController)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func showSearchContacts(on navigationController: UINavigationController) -> Observable<Void> {
        let showSearchContactsCoordinator = SearchContactsCoordinator(navigationController: navigationController)
        return coordinate(to: showSearchContactsCoordinator)
    }
}
