//
//  ChatCellViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/28/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class ChatCellViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let messageText: Driver<String>
        let username: Driver<String>
        let date: Driver<String>
        let profileImageUrl: Driver<URL?>
        let newMessagesCount: Driver<UInt>
    }
    
    let input: Input
    let output: Output
    let chat: Chat
    
    private let lastMessageSubject = PublishSubject<Message>()
    private let newMessagesCountSubject = PublishSubject<UInt>()
    private let messageTextSubject = PublishSubject<String>()
    private let dateSubject = PublishSubject<String>()
    private let profileImageUrlSubject = PublishSubject<URL?>()
    private let usernameSubject = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    private let user = AuthService.shared.currentUser
    private let firDatabase = FIRDatabaseManager()
    
    init(with chat: Chat) {
        self.chat = chat
        self.input = Input()
        
        self.output = Output(
            messageText: messageTextSubject.asDriver(onErrorJustReturn: ""),
            username: usernameSubject.asDriver(onErrorJustReturn: ""),
            date: dateSubject.asDriver(onErrorJustReturn: ""),
            profileImageUrl: profileImageUrlSubject.asDriver(onErrorJustReturn: nil),
            newMessagesCount: newMessagesCountSubject.asDriver(onErrorJustReturn: 0)
        )
        
        user.subscribe(onNext: { [weak self] (user) in
            guard let user = user else { return }
            
            self?.fetchUserInfo(user: user)
            self?.fetchMessagesCount(user: user)
        }).disposed(by: disposeBag)
        
        fetchLastMessage()
    }
    
    private func fetchMessagesCount(user: UserInfo) {
        firDatabase.fetchMessagesCount(chatId: chat.id,
                                       user: user) { [weak self] (count) in
            self?.newMessagesCountSubject.onNext(count)
        }
    }
    
    private func fetchUserInfo(user: UserInfo) {
        firDatabase.fetchUserInfo(userId: chat.companionId) { [weak self] (userInfo) in
            self?.usernameSubject.onNext(userInfo.username)
            self?.profileImageUrlSubject.onNext(userInfo.imageUrl)
        }
    }
    
    private func fetchLastMessage() {
        firDatabase.fetchLastMessage(chatId: chat.id) { [weak self] (message) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            if let date = dateFormatter.string(for: message.sentDate) {
                self?.dateSubject.onNext(date)
                self?.messageTextSubject.onNext(message.text)
            }
        }
    }
}
