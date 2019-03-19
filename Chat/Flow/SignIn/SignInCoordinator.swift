//
//  SignInCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class SignInCoordinator: Coordinator {
    
    lazy var viewModel = SignInViewModel()
    lazy var viewController: UIViewController = SignInViewController.create(with: viewModel)
    
    private let disposeBag = DisposeBag()
    
    func start(from navigationController: UINavigationController) -> Observable<Void> {
        navigationController.pushViewController(viewController, animated: true)
        
        viewModel.output.signUpObservable
            .drive(onNext: { _ in
                let signUpCoordinator = SignUpCoordinator()
                _ = self.coordinate(to: signUpCoordinator, from: navigationController)
            }).disposed(by: disposeBag)
        
        viewModel.output.resetPasswordObservable
            .drive(onNext: { _ in
                let resetPasswordCoordinator = ResetPasswordCoordinator()
                _ = self.coordinate(to: resetPasswordCoordinator, from: navigationController)
            }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    func coordinate(to coordinator: Coordinator, from viewController: UINavigationController) -> Observable<Void> {
        return coordinator.start(from: viewController)
    }
    
}
