//
//  CountriesCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift

class CountriesCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let viewModel = CountriesViewModel()
        let viewController = CountriesViewController.create(with: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        
        let result = viewModel.output.backButtonObservable.asObservable()
        
        return result.do(onNext: { [weak self] (_) in
            self?.navigationController.popViewController(animated: true)
        })
    }
}
