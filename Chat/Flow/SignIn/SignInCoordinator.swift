//
//  SignInCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseAuth

final class SignInCoordinator: BaseCoordinator<AuthDataResult> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<AuthDataResult> {
        let viewModel = SignInViewModel()
        let viewController = SignInViewController.create(with: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
        viewModel.output.resetPasswordObservable
            .flatMap({ [weak self] _ -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.showResetPassword(on: self.navigationController)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        return viewModel.output.resultObservable.take(1).do(onNext: { [weak self] (user) in
            self?.navigationController.popViewController(animated: false)
        })
    }
    
    private func showResetPassword(on navigationController: UINavigationController) -> Observable<Void> {
        let resetPasswordCoordinator = ResetPasswordCoordinator(navigationController: navigationController)
        return coordinate(to: resetPasswordCoordinator)
    }
    
}
