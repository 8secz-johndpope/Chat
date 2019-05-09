//
//  PhoneVerificationCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/2/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseAuth

enum PhoneVerificationResult {
    case back
    case verified(AuthDataResult)
}

final class PhoneVerificationCoordinator: BaseCoordinator<PhoneVerificationResult> {
    
    private let navigationController: UINavigationController
    private let phoneNumber: String
    
    init(navigationController: UINavigationController, phoneNumber: String) {
        self.navigationController = navigationController
        self.phoneNumber = phoneNumber
    }
    
    override func start() -> Observable<PhoneVerificationResult> {
        let viewModel = PhoneVerificationViewModel(phoneNumber: phoneNumber)
        let viewController = PhoneVerificationViewController.create(with: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        
        let backResult = viewModel.output.backButton
            .asObservable()
            .map { PhoneVerificationResult.back }
        
        let authResult = viewModel.output.authData
            .asObservable()
            .map { PhoneVerificationResult.verified($0) }
        
        return Observable.merge(backResult, authResult).do(onNext: { [weak self] (_) in
            self?.navigationController.popViewController(animated: false)
        })
    }
    
}
