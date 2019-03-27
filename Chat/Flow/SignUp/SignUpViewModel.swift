//
//  SignUpViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/19/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseAuth

class SignUpViewModel: ViewModelProtocol {
    
    //MARK: Input-Output
    struct Input {
        let username: AnyObserver<String>
        let email: AnyObserver<String>
        let password: AnyObserver<String>
        let signUpDidTap: AnyObserver<Void>
    }
    
    struct Output {
        let usernameObservable: Observable<String>
        let emailObservable: Observable<String>
        let passwordObservable: Observable<String>
        let resultObservable: Observable<User>
        let errorsObservable: Observable<Error>
    }
    
    let input: Input
    let output: Output
    
    //MARK: Subjects
    let usernameSubject = PublishSubject<String>()
    let emailSubject = PublishSubject<String>()
    let passwordSubject = PublishSubject<String>()
    let signUpSubject = PublishSubject<Void>()
    let resultSubject = PublishSubject<User>()
    let errorsSubject = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()
    
    private var credentialsObservable: Observable<(String, String)> {
        return Observable.combineLatest(output.emailObservable, output.passwordObservable) { (username, password) in
            return (username, password)
        }
    }
    
    //MARK: Init
    init() {
        self.input = Input(username: usernameSubject.asObserver(),
                           email: emailSubject.asObserver(),
                           password: passwordSubject.asObserver(),
                           signUpDidTap: signUpSubject.asObserver())
        
        self.output = Output(usernameObservable: usernameSubject.asObservable(),
                             emailObservable: emailSubject.asObservable(),
                             passwordObservable: passwordSubject.asObservable(),
                             resultObservable: resultSubject.asObservable(),
                             errorsObservable: errorsSubject.asObservable())
        
        signUpSubject.withLatestFrom(credentialsObservable)
            .flatMapLatest { (email, password) in
                return AuthenticationService.signUp(with: email, password: password).materialize()
            }.subscribe(onNext: { [weak self] (event) in
                switch event {
                case .next(let user):
                    self?.resultSubject.onNext(user)
                    self?.resultSubject.onCompleted()
                case .error(let error):
                    self?.errorsSubject.onNext(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    
}
