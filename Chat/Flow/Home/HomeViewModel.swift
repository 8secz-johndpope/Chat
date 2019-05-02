//
//  HomeViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/24/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift

class HomeViewModel: ViewModelProtocol {
    
    //MARK: Input-Output
    struct Input {
        let startMessaging: AnyObserver<Void>
    }
    
    struct Output {
        let startMessagingObservable: Observable<Void>
    }
    
    let input: Input
    let output: Output
    
    //MARK: Subjects
    private let startMessagingSubject = PublishSubject<Void>()
    
    //MARK: Init
    init() {
        self.input = Input(startMessaging: startMessagingSubject.asObserver())
        self.output = Output(startMessagingObservable: startMessagingSubject.asObservable())
    }
    
}
