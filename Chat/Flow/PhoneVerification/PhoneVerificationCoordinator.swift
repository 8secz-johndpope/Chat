//
//  PhoneVerificationCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/2/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class PhoneVerificationCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let viewModel = PhoneVerificationViewModel()
        let viewController = PhoneVerificationViewController.create(with: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        
        return Observable.never()
    }
    
}
