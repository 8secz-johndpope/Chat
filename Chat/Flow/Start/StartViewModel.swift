//
//  StartViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/27/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class StartViewModel: ViewModelProtocol {
    
    struct Input {
        let animationDidFinish: AnyObserver<Void>
    }
    
    struct Output {
        let isUserAuthorized: Observable<Bool>
    }
    
    let input: Input
    let output: Output
    
    private let isUserAuthorizedSubject = PublishSubject<Bool>()
    private let animationDidFinishSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.input = Input(animationDidFinish: animationDidFinishSubject.asObserver())
        self.output = Output(isUserAuthorized: isUserAuthorizedSubject.asObservable())
        
        animationDidFinishSubject.asObservable().subscribe(onNext: { [weak self] _ in
            self?.isUserAuthorizedSubject.onNext(AuthService.shared.isUserAuthorized())
        }).disposed(by: disposeBag)
    }
}
