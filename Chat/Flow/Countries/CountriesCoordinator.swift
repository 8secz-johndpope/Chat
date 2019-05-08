//
//  CountriesCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift

enum CountryCoordinatorResult {
    case cancel
    case country(Country)
}

class CountriesCoordinator: BaseCoordinator<CountryCoordinatorResult> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<CountryCoordinatorResult> {
        let viewModel = CountriesViewModel()
        let viewController = CountriesViewController.create(with: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        
        let cancel = viewModel.output
            .backButtonObservable
            .asObservable()
            .map { CountryCoordinatorResult.cancel }
        
        let country = viewModel.output
            .selectionObservable
            .asObservable()
            .map { CountryCoordinatorResult.country($0) }
        
        return Observable.merge(cancel, country).take(1).do(onNext: { [weak self] (_) in
            self?.navigationController.popViewController(animated: true)
        })
    }
}
