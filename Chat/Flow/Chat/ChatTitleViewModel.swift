//
//  ChatTitleViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/1/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class ChatTitleViewModel: ViewModelProtocol {
    
    struct Input {
        
    }
    
    struct Output {
        let imageUrl: Driver<URL?>
        let username: Driver<String>
        let status: Driver<String>
    }
    
    let input: Input
    let output: Output
    let userId: String
    
    private let imageUrlSubject = BehaviorRelay<URL?>(value: nil)
    private let usernameSubject = BehaviorRelay<String>(value: "")
    private let statusSubject = BehaviorRelay<String>(value: "")
    
    private let firDatabase = FIRDatabaseManager()
    private let disposeBag = DisposeBag()
    
    init(userId: String) {
        self.input = Input()
        self.output = Output(imageUrl: imageUrlSubject.asDriver(onErrorJustReturn: nil),
                             username: usernameSubject.asDriver(onErrorJustReturn: ""),
                             status: statusSubject.asDriver(onErrorJustReturn: ""))
        self.userId = userId
        
        fetchUserInfo()
        observeUserStatus()
    }
    
    private func observeUserStatus() {
        self.statusSubject.accept("loading...")
    }
    
    private func fetchUserInfo() {
        firDatabase.fetchUserInfo(userId: userId) { [weak self] (userInfo) in
            self?.imageUrlSubject.accept(userInfo.imageUrl)
            self?.usernameSubject.accept(userInfo.username)
        }
    }
}
