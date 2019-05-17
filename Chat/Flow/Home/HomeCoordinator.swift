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

final class HomeCoordinator: BaseCoordinator<UserInfo> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<UserInfo> {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController.create(with: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        window.rootViewController = navigationController
        
        let result = viewModel.output.startMessagingObservable
            .flatMap { [weak self] (_) -> Observable<PhoneVerificationResult> in
                guard let self = self else { return Observable.empty() }
                return self.showPhoneInput(on: navigationController)
            }.map { result -> UserInfo? in
                switch result {
                case .back:
                    return nil
                case .verified(let user):
                    return user
                }
            }
            .filter { $0 != nil }
            .map { $0! }
        
        return result
    }
    
    private func showPhoneInput(on navigationController: UINavigationController) -> Observable<PhoneVerificationResult> {
        let coordinator = PhoneInputCoordinator(navigationController: navigationController)
        return coordinate(to: coordinator)
    }
}
