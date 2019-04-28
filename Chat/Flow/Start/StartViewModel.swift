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
        let resultObservable: Observable<AuthResult>
    }
    
    let input: Input
    let output: Output
    
    private let resultSubject = PublishSubject<AuthResult>()
    private let animationDidFinishSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.input = Input(animationDidFinish: animationDidFinishSubject.asObserver())
        self.output = Output(resultObservable: resultSubject.asObservable())
        
        let authorized = AuthenticationManager.shared.wasAuthorized()
        
        animationDidFinishSubject.asObservable().subscribe(onNext: { [weak self] _ in
            self?.resultSubject.onNext(authorized ? .authorized : .notAuthorized)
        }).disposed(by: disposeBag)
    }
}
