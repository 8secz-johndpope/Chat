//
//  AppCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {
    
    var window: UIWindow
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        self.window = window
        self.window.rootViewController = navigationController
    }
    
    override func start() -> Observable<Void> {
        self.showHome(on: navigationController).subscribe().disposed(by: disposeBag)
        return Observable.never()
    }
    
    private func showHome(on navigationController: UINavigationController) -> Observable<Void> {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        return coordinate(to: homeCoordinator)
    }
}
