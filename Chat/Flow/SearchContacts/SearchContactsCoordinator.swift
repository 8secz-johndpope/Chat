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
        
        searchContactsViewModel.output.selectionObservable
            .flatMap({ [weak self] userInfo -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.showMessages(on: self.navigationController, with: userInfo)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func showMessages(on navigationController: UINavigationController, with user: UserInfo) -> Observable<Void> {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController,
                                              companion: user)
        return coordinate(to: chatCoordinator)
    }
}
