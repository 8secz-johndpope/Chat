//
//  HomeCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/24/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseAuth

final class HomeCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController.create(with: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        window.rootViewController = navigationController
        
        let _ = viewModel.output.startMessagingObservable
            .flatMapLatest { [weak self] (_) -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.showPhoneInput(on: navigationController)
            }.subscribe()
        
        return Observable.never()
    }
    
    private func showPhoneInput(on navigationController: UINavigationController) -> Observable<Void> {
        let coordinator = PhoneInputCoordinator(navigationController: navigationController)
        return coordinate(to: coordinator)
    }
}
