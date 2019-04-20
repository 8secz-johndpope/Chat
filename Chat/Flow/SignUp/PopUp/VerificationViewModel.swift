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
        let errorObservable: Observable<Error>
    }
    
    let input: Input
    let output: Output
    
    //MARK: Subjects
    private let buttonSubject = PublishSubject<Void>()
    private let changeViewSubject = PublishSubject<Void>()
    private let removeUserSubject = PublishSubject<AuthDataResult>()
    private let verifiedUserSubject = PublishSubject<AuthDataResult>()
    private let errorSubject = PublishSubject<Error>()
    
    private let authResult: AuthDataResult
    private let firDatabase = FIRDatabaseManager()
    private let disposeBag = DisposeBag()
    private let isUpdating = Variable(true)
    
    //MARK: Init
    init(authResult: AuthDataResult) {
        self.authResult = authResult
        self.input = Input(buttonDidTap: buttonSubject.asObserver())
        self.output = Output(changeViewObservable: changeViewSubject.asObservable(),
                             removeUserObservable: removeUserSubject.asObservable(),
                             verifiedUserObservable: verifiedUserSubject.asObservable(),
                             errorObservable: errorSubject.asObservable())
        
        isUpdating.asObservable()
            .flatMapLatest { (isUpdating) in
                isUpdating ? Observable<Int>.interval(3.0, scheduler: MainScheduler.instance) : .empty()
            }
            .flatMap { (index) in Observable.just(index) }
            .subscribe(onNext: { [weak self] (_) in
                if let value = Auth.auth().currentUser?.isEmailVerified, value {
                    self?.isUpdating.value = false
                    self?.uploadUser()
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
    
    func uploadUser() {
        let firUser = authResult.user
        let email = firUser.email ?? ""
        let userId = firUser.uid
        let username = firUser.displayName ?? ""
        let imageUrl = Constants.Firebase.Storage.profilePlaceholder
        
        let user = UserInfo(email: email, imageUrl: imageUrl, userId: userId, username: username)
        firDatabase.uploadUser(user) { (error) in
            if let error = error {
                self.errorSubject.onNext(error)
                self.errorSubject.onCompleted()
            } else {
                self.changeViewSubject.onNext(())
                self.changeViewSubject.onCompleted()
            }
        }
    }
    
    func removeUser() {
        authResult.user.delete()
    }
}
