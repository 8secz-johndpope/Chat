//
//  SignUpCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

final class SignUpCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let viewModel = SignUpViewModel()
        let viewController = SignUpViewController.create(with: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)

        return Observable.never()
    }

}
