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
        
        let result = viewModel.output.cancelButtonObservable.asObservable()
        
        viewModel.output
            .countryFlagButtonObservable
            .asObservable()
            .flatMap { [weak self] (_) -> Observable<CountryCoordinatorResult> in
                guard let self = self else { return Observable.empty() }
                return self.showCountries(on: self.navigationController)
            }.map { result -> Country? in
                switch result {
                case .cancel:
                    return nil
                case .country(let country):
                    return country
                }
            }
            .filter { $0 != nil }
            .map { $0!}
            .bind(to: viewModel.input.countrySelection)
            .disposed(by: disposeBag)
        
        return result.do(onNext: { [weak self] (_) in
            self?.navigationController.popViewController(animated: true)
        })
    }
    
    private func showCountries(on navigationController: UINavigationController) -> Observable<CountryCoordinatorResult> {
        let coordinator = CountriesCoordinator(navigationController: navigationController)
        return coordinate(to: coordinator)
    }
}
