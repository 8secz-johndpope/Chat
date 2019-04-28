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
    
    let sender: Sender
    let companion: UserInfo
    var chatId: String
    private var messages = BehaviorRelay<[Message]>(value: [])
    private var newMessageSubject = PublishSubject<Message>()
    private let firDatabase = FIRDatabaseManager()
    
    init(companion: UserInfo) {
        self.sender = Sender(id: Auth.auth().currentUser?.uid ?? "",
                             displayName: Auth.auth().currentUser?.displayName ?? "")
        self.companion = companion
        self.chatId = ""
        
        self.input = Input()
        self.output = Output(messagesObservable: messages.asObservable(),
                             newMessageObservable: newMessageSubject.asObservable())
        
        self.fetchMessages()
    }
    
    func sendMessage(_ message: Message) {
        messages.accept(messages.value + [message])
        firDatabase.uploadMessage(message, from: sender, to: companion)
    }
    
    func fetchMessage(_ message: Message) {
        let shouldRead = messages.value.map { $0.messageId }.contains(message.messageId)
        if shouldRead {
            firDatabase.readMessage(message, chatId: chatId, user: sender)
        } else {
            messages.accept(messages.value + [message])
            newMessageSubject.onNext(message)
        }
        
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
        firDatabase.getChatId(sender: sender, recipient: companion) { [weak self] (id, error) in
            guard let self = self else { return }
            if let chatId = id {
                self.chatId = chatId
                self.firDatabase.fetchMessages(chatId: chatId, completion: { (messages) in
                    for message in messages {
                        self.fetchMessage(message)
                    }
                    self.observeMessages()
                })
            } else {
                self.firDatabase.observeChatId(sender: self.sender, recipient: self.companion, completion: { (id, error) in
                    if let chatId = id {
                        self.chatId = chatId
                        self.observeMessages()
                    }
                })
            }
        }
    }
    
    func observeMessages() {
        firDatabase.observeMessages(chatId: chatId, sender: sender, recipient: companion) { [weak self] (message) in
            self?.fetchMessage(message)
        }
    }
    
    deinit {
        firDatabase.removeObservers()
    }
}
