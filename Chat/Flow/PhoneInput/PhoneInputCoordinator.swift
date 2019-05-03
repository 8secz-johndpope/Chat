//
//  PhoneInputCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/2/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class PhoneInputCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let viewModel = PhoneInputViewModel()
        let viewController = PhoneInputViewController.create(with: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        
        let result = viewModel.output
            .cancelButtonObservable
            .asObservable()
        
        return result.do(onNext: { [weak self] (_) in
            self?.navigationController.popViewController(animated: true)
        })
    }
    
}
