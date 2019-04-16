//
//  ContactsViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift

class ContactsViewModel {
    
    struct Input {
        let addContactButtonDidTap: AnyObserver<Void>
    }
    
    struct Output {
        let addContactButtonObservable: Observable<Void>
    }
    
    let input: Input
    let output: Output
    
    private let addContactButtonSubject = PublishSubject<Void>()
    
    init() {
        self.input = Input(addContactButtonDidTap: addContactButtonSubject.asObserver())
        self.output = Output(addContactButtonObservable: addContactButtonSubject.asObservable())
    }
}
