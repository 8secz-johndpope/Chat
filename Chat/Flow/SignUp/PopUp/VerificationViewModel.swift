//
//  VerificationViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/7/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseAuth
import RxFirebase

class VerificatiobViewModel: ViewModelProtocol {
    
    //MARK: Input-Output
    struct Input {
        let buttonDidTap: AnyObserver<Void>
    }
    
    struct Output {
        let changeViewObservable: Observable<Void>
        let removeUserObservable: Observable<AuthDataResult>
        let verifiedUserObservable: Observable<AuthDataResult>
    }
    
    let input: Input
    let output: Output
    
    //MARK: Subjects
    private let buttonSubject = PublishSubject<Void>()
    private let changeViewSubject = PublishSubject<Void>()
    private let removeUserSubject = PublishSubject<AuthDataResult>()
    private let verifiedUserSubject = PublishSubject<AuthDataResult>()
    
    private let authResult: AuthDataResult
    private let disposeBag = DisposeBag()
    
    //MARK: Init
    init(authResult: AuthDataResult) {
        self.authResult = authResult
        self.input = Input(buttonDidTap: buttonSubject.asObserver())
        self.output = Output(changeViewObservable: changeViewSubject.asObservable(),
                             removeUserObservable: removeUserSubject.asObservable(),
                             verifiedUserObservable: verifiedUserSubject.asObservable())
        
        Observable<Int>.interval(3.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                if let value = Auth.auth().currentUser?.isEmailVerified, value {
                    self?.changeViewSubject.onNext(())
                    self?.changeViewSubject.onCompleted()
                } else {
                    Auth.auth().currentUser?.reload()
                }
            })
            .disposed(by: disposeBag)
        
        buttonSubject.asObservable().subscribe(onNext: { [weak self] (_) in
            if Auth.auth().currentUser?.isEmailVerified ?? false {
                self?.verifiedUserSubject.onNext((authResult))
                self?.verifiedUserSubject.onCompleted()
            } else {
                self?.removeUserSubject.onNext((authResult))
                self?.removeUserSubject.onCompleted()
            }
        })
        .disposed(by: disposeBag)

    }
    
    func removeUser() {
        authResult.user.delete()
    }
}
