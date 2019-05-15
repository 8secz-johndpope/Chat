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
    private let user = AuthenticationManager.shared.user!
    private let firDatabase = FIRDatabaseManager()
    
    init() {
        fetchNewMessaggesCount()
    }
    
    private func fetchNewMessaggesCount() {
        firDatabase.fetchNewMessagesCount(user: user) { [weak self] (chatsCount) in
            self?.chatsCountWithNewMessages.accept(chatsCount)
        }
    }
}
