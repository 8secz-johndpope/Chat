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
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<AuthDataResult> {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController.create(with: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
        let signUpResult = viewModel.output.signUpObservable
            .flatMap({ [weak self] _ -> Observable<AuthDataResult> in
                guard let self = self else { return Observable.empty() }
                return self.showSignUp(on: self.navigationController)
            })
            .map { $0 }
        
        let signInResult = viewModel.output.signInObservable
            .flatMap({ [weak self] _ -> Observable<AuthDataResult> in
                guard let self = self else { return Observable.empty() }
                return self.showSignIn(on: self.navigationController)
            })
            .map { $0 }
        
        return Observable.merge(signInResult, signUpResult)
            .take(1)
            .do(onNext: { [weak self] (_) in
                self?.navigationController.popViewController(animated: false)
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
