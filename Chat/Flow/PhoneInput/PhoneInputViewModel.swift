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
    }
    
    struct Output {
        let cancelButtonObservable: Driver<Void>
        let verifyButtonObservable: Driver<Void>
    }
    
    let input: Input
    let output: Output
    
    private let cancelButtonSubject = PublishSubject<Void>()
    private let verifyButtonSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.input = Input(cancelButtonDidTap: cancelButtonSubject.asObserver(),
                           verifyButtonDidTap: verifyButtonSubject.asObserver())
        self.output = Output(cancelButtonObservable: cancelButtonSubject.asDriver(onErrorJustReturn: ()),
                             verifyButtonObservable: verifyButtonSubject.asDriver(onErrorJustReturn: ()))
    }
}
