//
//  CountriesSearchViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class CountriesViewModel: ViewModelProtocol {
    
    struct Input {
        let backButtonDidTap: AnyObserver<Void>
    }
    
    struct Output {
        let backButtonObservable: Driver<Void>
    }
    
    let input: Input
    let output: Output
    
    private let backButtonSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.input = Input(backButtonDidTap: backButtonSubject.asObserver())
        self.output = Output(backButtonObservable: backButtonSubject.asDriver(onErrorJustReturn: ()))
    }
}
