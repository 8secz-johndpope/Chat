//
//  AppCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseAuth

final class AppCoordinator: BaseCoordinator<Void> {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        showStart().subscribe(onNext: { [weak self] (result) in
            switch result {
            case .authorized:
                self?.showAuthorizedState()
            case .notAuthorized:
                self?.showNotAuthorizedState()
            }
        }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func showAuthorizedState() {
        self.showMainTabBar()
            .subscribe(onNext: { [weak self] (_) in
                self?.showNotAuthorizedState()
            })
            .disposed(by: disposeBag)
    }
    
    private func showNotAuthorizedState() {
        self.showHome()
            .subscribe(onNext: { [weak self] (user) in
                self?.showAuthorizedState()
            })
            .disposed(by: disposeBag)
    }
    
    private func showStart() -> Observable<AuthResult> {
        let startCoordinator = StartCoordinator(window: window)
        return coordinate(to: startCoordinator)
    }
    
    private func showHome() -> Observable<UserInfo> {
        let homeCoordinator = HomeCoordinator(window: window)
        return coordinate(to: homeCoordinator)
    }
    
    private func showMainTabBar() -> Observable<Void> {
        let mainTabBarCoordinator = MainTabBarCoordinator(window: window)
        return coordinate(to: mainTabBarCoordinator)
    }
}
