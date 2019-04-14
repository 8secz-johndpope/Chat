//
//  VerificationCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/7/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseAuth

enum SignUpResult {
    case verified(AuthDataResult)
    case canceled
}

final class VerificationCoordinator: BaseCoordinator<SignUpResult> {
    
    private var navigationController: UINavigationController
    private var authResult: AuthDataResult
    
    init(navigationController: UINavigationController, authResult: AuthDataResult) {
        self.navigationController = navigationController
        self.authResult = authResult
    }
    
    override func start() -> Observable<SignUpResult> {
        let viewModel = VerificatiobViewModel(authResult: authResult)
        let viewController = VerificationViewController.create(with: viewModel)
        
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        
        navigationController.present(viewController, animated: true)
        
        let verified = viewModel.output.verifiedUserObservable.map {
            SignUpResult.verified($0)
        }
        
        let remove = viewModel.output.removeUserObservable.map { _ -> SignUpResult in
            viewModel.removeUser()
            return SignUpResult.canceled
        }

        return Observable.merge(verified, remove)
            .take(1)
            .do(onNext: { _ in
                viewController.dismiss(animated: true)
            })
    }
}
