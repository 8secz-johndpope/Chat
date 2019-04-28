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

final class HomeCoordinator: BaseCoordinator<AuthDataResult> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<AuthDataResult> {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController.create(with: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        
        let signUpResult = viewModel.output.signUpObservable
            .flatMap({ [weak self] _ -> Observable<AuthDataResult> in
                guard let self = self else { return Observable.empty() }
                return self.showSignUp(on: navigationController)
            })
            .map { $0 }
        
        let signInResult = viewModel.output.signInObservable
            .flatMap({ [weak self] _ -> Observable<AuthDataResult> in
                guard let self = self else { return Observable.empty() }
                return self.showSignIn(on: navigationController)
            })
            .map { $0 }
        
        return Observable.merge(signInResult, signUpResult)
            .take(1)
            .do(onNext: { (_) in
                navigationController.popViewController(animated: false)
            })
    }
    
    private func showSignUp(on navigationController: UINavigationController) -> Observable<AuthDataResult> {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        return coordinate(to: signUpCoordinator)
    }
    
    private func showSignIn(on navigationController: UINavigationController) -> Observable<AuthDataResult> {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        return coordinate(to: signInCoordinator)
    }
}
