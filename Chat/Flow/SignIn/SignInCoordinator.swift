//
//  SignInCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

final class SignInCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let viewModel = SignInViewModel()
        let viewController = SignInViewController.create(with: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
        viewModel.output.resetPasswordObservable.flatMap({ [weak self] _ -> Observable<Void> in
            guard let self = self else { return Observable.empty() }
            return self.showResetPassword(on: self.navigationController)
        })
        .subscribe()
        .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func showResetPassword(on navigationController: UINavigationController) -> Observable<Void> {
        let resetPasswordCoordinator = ResetPasswordCoordinator(navigationController: navigationController)
        return coordinate(to: resetPasswordCoordinator)
    }
}
