//
//  StartCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/27/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import FirebaseAuth
import RxSwift

enum AuthResult {
    case authorized
    case notAuthorized
}

final class StartCoordinator: BaseCoordinator<AuthResult> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<AuthResult> {
        let viewModel = StartViewModel()
        let viewController = StartViewController.create(with: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
        return viewModel.output.resultObservable.take(1).do(onNext: { [weak self] (_) in
            self?.navigationController.popViewController(animated: false)
        })
    }
}
