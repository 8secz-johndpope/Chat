//
//  HomeViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/24/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift

class HomeViewModel: ViewModelProtocol {
    
    //MARK: Input-Output
    struct Input {
        let signInDidTap: AnyObserver<Void>
        let signUpDidTap: AnyObserver<Void>
    }
    
    struct Output {
        let signInObservable: Observable<Void>
        let signUpObservable: Observable<Void>
    }
    
    let input: Input
    let output: Output
    
    //MARK: Subjects
    private let signInSubject = PublishSubject<Void>()
    private let signUpSubject = PublishSubject<Void>()
    
    //MARK: Init
    init() {
        self.input = Input(signInDidTap: signInSubject.asObserver(),
                           signUpDidTap: signUpSubject.asObserver())
        
        self.output = Output(signInObservable: signInSubject.asObservable(),
                             signUpObservable: signUpSubject.asObservable())
    }
    
}
