//
//  PhoneInputCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/2/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseAuth

final class PhoneInputCoordinator: BaseCoordinator<PhoneVerificationResult> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<PhoneVerificationResult> {
        let viewModel = PhoneInputViewModel()
        let viewController = PhoneInputViewController.create(with: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        
        let backResult = viewModel.output.cancelButtonObservable
            .asObservable()
            .map { PhoneVerificationResult.back }
        
        viewModel.output
            .countryFlagButtonObservable
            .asObservable()
            .flatMap { [weak self] (_) -> Observable<CountryCoordinatorResult> in
                guard let self = self else { return Observable.empty() }
                return self.showCountries(on: self.navigationController)
            }
            .map { result -> Country? in
                switch result {
                case .cancel:
                    return nil
                case .country(let country):
                    return country
                }
            }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: viewModel.input.countrySelection)
            .disposed(by: disposeBag)
        
        let verifyResult = viewModel.output.verifyNumber
            .flatMap { [weak self] phoneNumber -> Observable<PhoneVerificationResult> in
                guard let self = self else { return Observable.empty() }
                return self.showPhoneVerification(on: self.navigationController,
                                                  phoneNumber: phoneNumber)
            }
            .filter {
                switch $0 {
                case .back:
                    return false
                case .verified:
                    return true
                }
            }
        
        return Observable.merge(backResult, verifyResult).do(onNext: { [weak self] (_) in
            self?.navigationController.popViewController(animated: false)
        })
    }
    
    private func showCountries(on navigationController: UINavigationController) -> Observable<CountryCoordinatorResult> {
        let coordinator = CountriesCoordinator(navigationController: navigationController)
        return coordinate(to: coordinator)
    }
    
    private func showPhoneVerification(on navigationController: UINavigationController,
                                       phoneNumber: String) -> Observable<PhoneVerificationResult> {
        let coordinator = PhoneVerificationCoordinator(navigationController: navigationController,
                                                       phoneNumber: phoneNumber)
        return coordinate(to: coordinator)
    }
}
