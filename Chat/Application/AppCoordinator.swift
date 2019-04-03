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
        self.navigationController = UINavigationController()
        self.window = window
        self.window.rootViewController = navigationController
    }
    
    override func start() -> Observable<Void> {
        self.showHome(on: navigationController)
            .subscribe(onNext: { [weak self] (user) in
                guard let self = self else { return }
                self.showMainTabBar(on: self.navigationController)
            })
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func showHome(on navigationController: UINavigationController) -> Observable<User> {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        return coordinate(to: homeCoordinator)
    }
    
    private func showMainTabBar(on navigationController: UINavigationController) {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        coordinate(to: mainTabBarCoordinator).subscribe().disposed(by: disposeBag)
    }
}
