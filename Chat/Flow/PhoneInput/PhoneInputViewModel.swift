//
//  PhoneInputViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/2/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class PhoneInputViewModel: ViewModelProtocol {
    
    struct Input {
        let cancelButtonDidTap: AnyObserver<Void>
        let verifyButtonDidTap: AnyObserver<Void>
        let countryFlagButtonDidTap: AnyObserver<Void>
        let countrySelection: AnyObserver<Country>
        let region: AnyObserver<String>
    }
    
    struct Output {
        let cancelButtonObservable: Driver<Void>
        let verifyButtonObservable: Driver<Void>
        let countryFlagButtonObservable: Driver<Void>
        let countrySelection: Observable<Country>
        let countryFlag: Driver<UIImage>
    }
    
    let input: Input
    let output: Output
    
    let country = BehaviorRelay<Country?>(value: nil)
    private let regionSubject = PublishSubject<String>()
    private let cancelButtonSubject = PublishSubject<Void>()
    private let verifyButtonSubject = PublishSubject<Void>()
    private let countryFlagButtonSubject = PublishSubject<Void>()
    private let countrySelectionsubject = PublishSubject<Country>()
    private let countryFlagSubject = PublishSubject<UIImage>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.input = Input(
            cancelButtonDidTap: cancelButtonSubject.asObserver(),
            verifyButtonDidTap: verifyButtonSubject.asObserver(),
            countryFlagButtonDidTap: countryFlagButtonSubject.asObserver(),
            countrySelection: countrySelectionsubject.asObserver(),
            region: regionSubject.asObserver()
        )
        
        self.output = Output(
            cancelButtonObservable: cancelButtonSubject.asDriver(onErrorJustReturn: ()),
            verifyButtonObservable: verifyButtonSubject.asDriver(onErrorJustReturn: ()),
            countryFlagButtonObservable: countryFlagButtonSubject.asDriver(onErrorJustReturn: ()),
            countrySelection: countrySelectionsubject.asObservable(),
            countryFlag: countryFlagSubject.asDriver(onErrorJustReturn: UIImage())
        )
        
        output.countrySelection.subscribe(onNext: { [weak self] (country) in
            let imageName = "countries/\(country.code)"
            let image = UIImage(named: imageName) ?? UIImage()
            
            self?.country.accept(country)
            self?.countryFlagSubject.onNext(image)
        }).disposed(by: disposeBag)
        
        regionSubject.asObservable()
            .subscribe(onNext: { [weak self] (region) in
                let imageName = "countries/\(region)"
                let image = UIImage(named: imageName) ?? UIImage()
                
                self?.countryFlagSubject.onNext(image)
            }).disposed(by: disposeBag)
    }
}
