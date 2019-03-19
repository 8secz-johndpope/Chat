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
    
    var signInViewController: SignInViewController?
    lazy var signInViewModel = SignInViewModel()
    lazy var signUpCoordinator = SignUpCoordinator()
    lazy var resetPasswordCoordinator = ResetPasswordCoordinator()
    private let disposeBag = DisposeBag()
    
    func start(from viewController: UINavigationController) -> Observable<Void> {
        let signInViewController = R.storyboard.auth.instantiateInitialViewController()
        signInViewController?.viewModel = signInViewModel
        
        viewController.pushViewController(signInViewController!, animated: true)
        
        signInViewModel.resetPasswordAction.drive(onNext: { [unowned self] () in
            _ = self.coordinate(to: self.resetPasswordCoordinator, from: viewController)
        }).disposed(by: disposeBag)
        
        signInViewModel.signUpAction.drive(onNext: { [unowned self] () in
            _ = self.coordinate(to: self.signUpCoordinator, from: viewController)
        }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    func coordinate(to coordinator: Coordinator, from viewController: UINavigationController) -> Observable<Void> {
        return coordinator.start(from: viewController)
    }
    
}
