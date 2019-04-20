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
        let username = BehaviorRelay(value: "")
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
                return Auth.auth().rx.createUser(withEmail: email, password: password)
            }.flatMapLatest { [weak self] (authResult) -> Observable<Event<AuthDataResult>> in
                guard let self = self else { return Observable.empty() }
                return self.profileChangeRequest(authResult: authResult).materialize()
            }
            .subscribe(onNext: { [weak self] (event) in
                switch event {
                case .next(let authResult):
                    Auth.auth().currentUser?.sendEmailVerification()
                    self?.resultSubject.onNext(authResult)
                case .error(let error):
                    self?.errorsSubject.onNext(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func profileChangeRequest(authResult: AuthDataResult) -> Observable<AuthDataResult> {
        return Observable.create({ (observer) -> Disposable in
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = self.input.username.value
            changeRequest.commitChanges(completion: { (error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(authResult)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
    
}
