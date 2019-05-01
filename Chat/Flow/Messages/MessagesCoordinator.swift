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
        
        messagesViewModel.output
            .fetchCompanionObservable
            .flatMapLatest { [weak self] (companion) -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.showChat(on: self.navigationController, companion: companion)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func showChat(on navigationController: UINavigationController,
                          companion: UserInfo) -> Observable<Void> {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController,
                                              companion: companion)
        return coordinate(to: chatCoordinator)
    }

}
