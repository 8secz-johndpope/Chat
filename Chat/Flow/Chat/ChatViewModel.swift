//
//  ChatViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/19/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa
import MessageKit
import FirebaseAuth

class ChatViewModel: ViewModelProtocol {
    
    struct Input {
        
    }
    
    struct Output {
        var messagesObservable: Observable<[Message]>
        var newMessageObservable: Observable<Message>
    }
    
    let input: Input
    let output: Output
    
    let currentUser: Sender
    let companion: UserInfo
    var chatId: String
    private var messages = BehaviorRelay<[Message]>(value: [])
    private var newMessageSubject = PublishSubject<Message>()
    private let firDatabase = FIRDatabaseManager()
    
    init(companion: UserInfo, chatId: String = "") {
        self.currentUser = Sender(id: AuthService.shared.user?.userId ?? "",
                                  displayName: AuthService.shared.user?.username ?? "")
        self.companion = companion
        self.chatId = chatId
        
        self.input = Input()
        self.output = Output(messagesObservable: messages.asObservable(),
                             newMessageObservable: newMessageSubject.asObservable())
        
        self.fetchMessages()
    }
    
    func sendMessage(_ message: Message) {
        messages.accept(messages.value + [message])
        firDatabase.uploadMessage(message, from: currentUser, to: companion)
    }
    
    func fetchMessage(_ message: Message) {
        if !message.wasRead, message.sender.id != currentUser.id {
            message.wasRead = true
            firDatabase.readMessage(message, chatId: chatId, user: currentUser)
        }
        
        messages.accept(messages.value + [message])
        newMessageSubject.onNext(message)
    }
    
    func getMessagesCount() -> Int {
        return messages.value.count
    }
    
    func sortMessages() {
        messages.accept(messages.value.sorted())
    }
    
    func getMessage(at index: Int) -> Message {
        return messages.value[index]
    }
    
    func fetchMessages() {
        self.firDatabase.observeChatId(sender: currentUser,
                                       recipient: companion,
                                       completion: { [weak self] (id, error) in
            if let chatId = id {
                self?.chatId = chatId
                self?.observeMessages()
            }
        })
    }
    
    func observeMessages() {
        firDatabase.fetchMessages(chatId: chatId) { [weak self] (messages) in
            self?.messages.accept([])
            for message in messages {
                self?.fetchMessage(message)
            }
        }
    }
    
    deinit {
        firDatabase.removeObservers()
    }
}
