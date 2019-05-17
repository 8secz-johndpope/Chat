//
//  StartCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/27/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import FirebaseAuth
import RxSwift

enum AuthResult {
    case authorized
    case notAuthorized
}

final class StartCoordinator: BaseCoordinator<AuthResult> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<AuthResult> {
        let viewModel = StartViewModel()
        let viewController = StartViewController.create(with: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        
        let result = viewModel.output.isUserAuthorized
            .map { $0 == true ? AuthResult.authorized : AuthResult.notAuthorized}
        
        return result.take(1).do(onNext: { (_) in
            navigationController.popViewController(animated: false)
        })
    }
}
