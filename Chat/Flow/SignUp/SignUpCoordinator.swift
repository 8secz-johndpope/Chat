//
//  SignUpCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseAuth

final class SignUpCoordinator: BaseCoordinator<AuthDataResult> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<AuthDataResult> {
        let viewModel = SignUpViewModel()
        let viewController = SignUpViewController.create(with: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
        let signUpResult = viewModel.output.resultObservable
            .flatMap({ [weak self] authResult -> Observable<SignUpResult> in
                guard let self = self else { return Observable.empty() }
                return self.showEmailVerification(with: authResult)
            })
            .map { (result) -> AuthDataResult? in
                switch result {
                case .verified(let authResult):
                    return authResult
                case .canceled:
                    return nil
                }
            }
            .filter { $0 != nil}
            .map { $0! }
        
        return signUpResult
    }

    private func showEmailVerification(with authResult: AuthDataResult) -> Observable<SignUpResult> {
        let verificationCoordinator = VerificationCoordinator(navigationController: navigationController,
                                                              authResult: authResult)
        return coordinate(to: verificationCoordinator)
    }
}
