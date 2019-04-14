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
        let email = BehaviorSubject(value: "")
        let username = BehaviorSubject(value: "")
        let password = BehaviorSubject(value: "")
        let signUpDidTap: AnyObserver<Void>
    }
    
    struct Output {
        let resultObservable: Observable<AuthDataResult>
        let errorsObservable: Observable<Error>
    }
    
    let input: Input
    let output: Output
    
    //MARK: Subjects
    private let signUpSubject = PublishSubject<Void>()
    private let resultSubject = PublishSubject<AuthDataResult>()
    private let errorsSubject = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()
    
    private var credentialsObservable: Observable<(String, String)> {
        return Observable.combineLatest(input.email, input.password) { (username, password) in
            return (username, password)
        }
    }
    
    //MARK: Init
    init() {
        self.input = Input(signUpDidTap: signUpSubject.asObserver())
        
        self.output = Output(resultObservable: resultSubject.asObservable(),
                             errorsObservable: errorsSubject.asObservable())
        
        signUpSubject.withLatestFrom(credentialsObservable)
            .flatMapLatest { (email, password) in
                return Auth.auth().rx.createUser(withEmail: email, password: password).materialize()
            }.subscribe(onNext: { [weak self] (event) in
                switch event {
                case .next(let user):
                    Auth.auth().currentUser?.sendEmailVerification()
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
