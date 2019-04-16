//
//  SearchContactsCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/16/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift

class SearchContactsCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let searchContactsViewModel = SearchContactsViewModel()
        let searchContactsViewController = SearchContactsViewController.create(with: searchContactsViewModel)
        navigationController.pushViewController(searchContactsViewController, animated: true)
        
        return Observable.never()
    }
    
}
