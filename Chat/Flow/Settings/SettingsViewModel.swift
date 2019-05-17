//
//  SettingsViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class SettingsViewModel: ViewModelProtocol {
    
    struct Input {
        let logoutButtonDidTap: AnyObserver<Void>
    }
    
    struct Output {
        let logoutObservable: Observable<Void>
    }
    
    let input: Input
    let output: Output
    
    private let logoutSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.input = Input(logoutButtonDidTap: logoutSubject.asObserver())
        self.output = Output(logoutObservable: logoutSubject.asObservable())
        
        output.logoutObservable.subscribe(onNext: { (_) in
            AuthService.shared.logout()
        }).disposed(by: disposeBag)
    }
}
