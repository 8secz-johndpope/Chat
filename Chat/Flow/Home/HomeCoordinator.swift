//
//  HomeCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/24/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

final class HomeCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController.create(with: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
        viewModel.output.signInObservable.flatMap({ [weak self] _ -> Observable<Void> in
            guard let self = self else { return Observable.empty() }
            return self.showSignIn(on: self.navigationController)
        })
        .subscribe()
        .disposed(by: disposeBag)
        
        viewModel.output.signUpObservable.flatMap({ [weak self] _ -> Observable<Void> in
            guard let self = self else { return Observable.empty() }
            return self.showSignUp(on: self.navigationController)
        })
        .subscribe()
        .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func showSignUp(on navigationController: UINavigationController) -> Observable<Void> {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        return coordinate(to: signUpCoordinator)
    }
    
    private func showSignIn(on navigationController: UINavigationController) -> Observable<Void> {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        return coordinate(to: signInCoordinator)
    }
}
