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
    
    //MARK: Input-Output
    struct Input {
        let username: AnyObserver<String>
        let password: AnyObserver<String>
        let signInDidTap: AnyObserver<Void>
        let resetPasswordDidTap: AnyObserver<Void>
    }
    
    struct Output {
        let usernameObservable: Observable<String>
        let passwordObservable: Observable<String>
        let resultObservable: Observable<User>
        let errorsObservable: Observable<Error>
        let resetPasswordObservable: Observable<Void>
    }
    
    let input: Input
    let output: Output
    
    //MARK: Subjects
    private let signInSubject = PublishSubject<Void>()
    private let resetPasswordSubject = PublishSubject<Void>()
    private let resultSubject = PublishSubject<User>()
    private let errorsSubject = PublishSubject<Error>()
    private let usernameSubject = PublishSubject<String>()
    private let passwordSubject = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    private var credentialsObservable: Observable<(String, String)> {
        return Observable.combineLatest(output.usernameObservable, output.passwordObservable) { (username, password) in
            return (username, password)
        }
    }
    
    //MARK: Init
    init() {
        self.input = Input(username: usernameSubject.asObserver(),
                           password: passwordSubject.asObserver(),
                           signInDidTap: signInSubject.asObserver(),
                           resetPasswordDidTap: resetPasswordSubject.asObserver())
        
        self.output = Output(usernameObservable: usernameSubject.asObservable(),
                             passwordObservable: passwordSubject.asObservable(),
                             resultObservable: resultSubject.asObservable(),
                             errorsObservable: errorsSubject.asObservable(),
                             resetPasswordObservable: resetPasswordSubject.asObservable())
        
        signInSubject.withLatestFrom(credentialsObservable)
            .flatMapLatest { (email, password) in
                return AuthenticationService.signIn(with: email, password: password).materialize()
            }.subscribe(onNext: { [weak self] (event) in
                switch event {
                case .next(let user):
                    self?.resultSubject.onNext(user)
                case .error(let error):
                    self?.errorsSubject.onNext(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
}
