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

class ChatViewModel: ViewModelProtocol {
    
    struct Input {
        
    }
    
    struct Output {
        var messagesObservable: Observable<[Message]>
    }
    
    let input: Input
    let output: Output
    
    let recipient: UserInfo
    var messages = BehaviorRelay<[Message]>(value: [])
    
    init(recipient: UserInfo) {
        self.recipient = recipient
        
        self.input = Input()
        self.output = Output(messagesObservable: messages.asObservable())
    }
    
    func sendMessage(_ message: Message) {
        messages.accept(messages.value + [message])
    }
}
