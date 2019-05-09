//
//  PhoneInputViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/2/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa
import PhoneNumberKit

final class PhoneInputViewModel: ViewModelProtocol {
    
    struct Input {
        let cancelButtonDidTap: AnyObserver<Void>
        let verifyButtonDidTap: AnyObserver<Void>
        let countryFlagButtonDidTap: AnyObserver<Void>
        let countrySelection: AnyObserver<Country>
        let region: AnyObserver<String>
        let isValidNumber: AnyObserver<Bool>
        let phoneNumber = BehaviorRelay<String>(value: "")
    }
    
    struct Output {
        let cancelButtonObservable: Driver<Void>
        let verifyNumber: Observable<String>
        let countryFlagButtonObservable: Driver<Void>
        let countrySelection: Observable<Country>
        let countryFlag: Driver<UIImage>
        let isValidNumber: Driver<Bool>
        let verifyButtonColor = BehaviorRelay<UIColor>(value: .gray)
        let region = BehaviorRelay<String>(value: "+")
    }
    
    let input: Input
    let output: Output
    
    let country = BehaviorRelay<Country?>(value: nil)
    private let phoneNumberSubject = PublishSubject<String>()
    private let isValidNumberSubject = PublishSubject<Bool>()
    private let regionSubject = PublishSubject<String>()
    private let cancelButtonSubject = PublishSubject<Void>()
    private let verifyButtonSubject = PublishSubject<Void>()
    private let verifyNumberSubject = PublishSubject<String>()
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
            region: regionSubject.asObserver(),
            isValidNumber: isValidNumberSubject.asObserver()
        )
        
        self.output = Output(
            cancelButtonObservable: cancelButtonSubject.asDriver(onErrorJustReturn: ()),
            verifyNumber: verifyNumberSubject.asObservable(),
            countryFlagButtonObservable: countryFlagButtonSubject.asDriver(onErrorJustReturn: ()),
            countrySelection: countrySelectionsubject.asObservable(),
            countryFlag: countryFlagSubject.asDriver(onErrorJustReturn: UIImage()),
            isValidNumber: isValidNumberSubject.asDriver(onErrorJustReturn: false)
        )
        
        output.isValidNumber
            .map { isValid -> UIColor in return isValid ? .blue : .gray }
            .drive(output.verifyButtonColor)
            .disposed(by: disposeBag)
        
        output.countrySelection
            .subscribe(onNext: { [weak self] (country) in
                self?.country.accept(country)
                self?.output.region.accept("+\(String(country.phoneCode))")
                self?.regionSubject.onNext(country.code)
            })
            .disposed(by: disposeBag)
        
        regionSubject.asObservable()
            .subscribe(onNext: { [weak self] (region) in
                let imageName = "countries/\(region)"
                let image = UIImage(named: imageName) ?? UIImage()
                
                self?.countryFlagSubject.onNext(image)
            })
            .disposed(by: disposeBag)
        
        verifyButtonSubject.asObservable()
            .subscribe(onNext: { [weak self] (_) in
                let phoneNumber = self?.input.phoneNumber.value ?? ""
                self?.veriphyPhoneNumber(phoneNumber)
            })
            .disposed(by: disposeBag)
    }
    
    func veriphyPhoneNumber(_ phoneNumber: String) {
        guard let number = try? PhoneNumberKit().parse(phoneNumber) else { return }
        let phone = PhoneNumberKit().format(number, toType: .e164)
        
        AuthenticationManager.shared.sendCode(to: phone) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                self?.verifyNumberSubject.onNext(phoneNumber)
            }
        }
    }
}
