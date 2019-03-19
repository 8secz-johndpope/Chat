//
//  SignInViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

class SignInViewModel: ViewModelProtocol {
    
    struct Input {
        let username: AnyObserver<String>
        let password: AnyObserver<String>
        let signInDidTap: AnyObserver<Void>
        let signUpDidTap: AnyObserver<Void>
        let resetPasswordDidTap: AnyObserver<Void>
    }
    
    struct Output {
        let resultObservable: Observable<User>
        let errorsObservable: Observable<Error>
        let signUpObservable: Driver<Void>
        let resetPasswordObservable: Driver<Void>
    }
    
    let input: Input
    let output: Output
    
    private let usernameSubject = PublishSubject<String>()
    private let passwordSubject = PublishSubject<String>()
    private let signInSubject = PublishSubject<Void>()
    private let signUpSubject = PublishSubject<Void>()
    private let resetPasswordSubject = PublishSubject<Void>()
    private let resultSubject = PublishSubject<User>()
    private let errorsSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    private let authenticationService = AuthenticationService()
    
    private var credentialsObservable: Observable<Credentials> {
        return Observable.combineLatest(usernameSubject.asObservable(), passwordSubject.asObservable()) { (username, password) in
            return Credentials(username: username, password: password)
        }
    }
    
    init() {
        self.input = Input(username: usernameSubject.asObserver(),
                           password: passwordSubject.asObserver(),
                           signInDidTap: signInSubject.asObserver(),
                           signUpDidTap: signUpSubject.asObserver(),
                           resetPasswordDidTap: resetPasswordSubject.asObserver())
        
        self.output = Output(resultObservable: resultSubject.asObservable(),
                             errorsObservable: errorsSubject.asObservable(),
                             signUpObservable: signUpSubject.asDriver(onErrorJustReturn: ()),
                             resetPasswordObservable: resetPasswordSubject.asDriver(onErrorJustReturn: ()))
        
        self.signInSubject.withLatestFrom(credentialsObservable)
            .flatMapLatest { (credentials) in
                return self.authenticationService.signIn(with: credentials).materialize()
            }.subscribe(onNext: { [unowned self] (event) in
                switch event {
                case .next(let user):
                    self.resultSubject.onNext(user)
                case .error(let error):
                    self.errorsSubject.onNext(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
}
