//
//  MainCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/30/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

final class MainTabBarCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let tabBarController = MainTabBarController.create()
        navigationController.present(tabBarController, animated: true)
        
        return Observable.never()
    }
}
