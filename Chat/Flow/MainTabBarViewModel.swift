//
//  MainTabBarViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/14/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class MainTabBarViewModel {
    
    let chatsCountWithNewMessages = BehaviorRelay<UInt>(value: 0)
    private let user = AuthService.shared.currentUser
    private let firDatabase = FIRDatabaseManager()
    private let disposeBag = DisposeBag()
    
    init() {
        user.subscribe(onNext: { [weak self] (user) in
            guard let user = user else { return }
            self?.fetchNewMessaggesCount(user: user)
        }).disposed(by: disposeBag)
    }
    
    private func fetchNewMessaggesCount(user: UserInfo) {
        firDatabase.fetchNewMessagesCount(user: user) { [weak self] (chatsCount) in
            self?.chatsCountWithNewMessages.accept(chatsCount)
        }
    }
}
