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
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.navigationController = UINavigationController(rootViewController: UIViewController())
        self.window = window
        self.window.rootViewController = navigationController
    }
    
    override func start() -> Observable<Void> {
        showStart(on: navigationController).subscribe(onNext: { [weak self] (result) in
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
        self.showMainTabBar(on: navigationController)
            .subscribe(onNext: { [weak self] (_) in
                self?.showNotAuthorizedState()
            })
            .disposed(by: disposeBag)
    }
    
    private func showNotAuthorizedState() {
        self.showHome(on: navigationController)
            .subscribe(onNext: { [weak self] (user) in
                self?.showAuthorizedState()
            })
            .disposed(by: disposeBag)
    }
    
    private func showStart(on navigationController: UINavigationController) -> Observable<AuthResult> {
        let startCoordinator = StartCoordinator(navigationController: navigationController)
        return coordinate(to: startCoordinator)
    }
    
    private func showHome(on navigationController: UINavigationController) -> Observable<AuthDataResult> {
        let homeCoordinator = HomeCoordinator(window: window)
        return coordinate(to: homeCoordinator)
    }
    
    private func showMainTabBar(on navigationController: UINavigationController) -> Observable<Void> {
        let mainTabBarCoordinator = MainTabBarCoordinator(window: window)
        return coordinate(to: mainTabBarCoordinator)
    }
}
