//
//  SignInViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class SignInViewModel {
    
    // MARK: Public Properties - Inputs
    let inputUserLogin: AnyObserver<String?>
    let inputUserPassword: AnyObserver<String?>
    
    let resetPasswordActionObserver: AnyObserver<Void>
    let signUpActionObserver: AnyObserver<Void>
    let signInActionObserver: AnyObserver<Void>
    
    // MARK: Public Properties - Outputs
    let isDoneButtonEnabled: Driver<Bool>
    let signUpAction: Driver<Void>
    let signInAction: Driver<Void>
    let resetPasswordAction: Driver<Void>
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    init() {
        let _inputUserLogin = BehaviorSubject<String?>(value: nil)
        let _inputUserPassword = BehaviorSubject<String?>(value: nil)
        
        inputUserLogin = _inputUserLogin.asObserver()
        inputUserPassword = _inputUserPassword.asObserver()
        
        isDoneButtonEnabled = _inputUserLogin.asObservable()
            .map({ $0?.count != 0 })
            .asDriver(onErrorJustReturn: false)
        
        let _signInAction = PublishSubject<Void>()
        self.signInAction = _signInAction.asDriver(onErrorJustReturn: ())
        self.signInActionObserver = _signInAction.asObserver()
        
        _signInAction.withLatestFrom(_inputUserLogin).bind { (login) in
            //demoSDK.authService.loginObserver.onNext(login)
        }.disposed(by: disposeBag)
        
        let _resetPasswordAction = PublishSubject<Void>()
        self.resetPasswordAction = _resetPasswordAction.asDriver(onErrorJustReturn: ())
        self.resetPasswordActionObserver = _resetPasswordAction.asObserver()
        
        let _signUpAction = PublishSubject<Void>()
        self.signUpAction = _signUpAction.asDriver(onErrorJustReturn: ())
        self.signUpActionObserver = _signUpAction.asObserver()
    }
    
//    private func signIn(email: String, password: String) -> Observable<User> {
//        
//    }
}
