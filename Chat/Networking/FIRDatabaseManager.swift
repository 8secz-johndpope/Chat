//
//  FIRDatabaseManager.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/16/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxFirebaseDatabase
import FirebaseDatabase
import FirebaseAuth
import RxSwift
import MessageKit

enum FIRError: Error {
    case parseError
}

class FIRDatabaseManager {
    
    struct Constants {
        static let users = "users"
        static let usersMessages = "users"
        static let info = "info"
        static let chats = "chats"
        static let username = "username"
        static let chatId = "chatId"
        static let messages = "messages"
        static let lastMessageId = "lastMessageId"
        static let newMessages = "newMessages"
        static let messageId = "messageId"
        static let senderId = "senderId"
        static let imageUrl = "imageUrl"
        static let title = "title"
        static let companionId = "companionId"
    }
    
    private let databaseRef = Database.database().reference().child("IOS_TEST")
    private lazy var usersRef = databaseRef.child(Constants.users)
    private lazy var chatsRef = databaseRef.child(Constants.chats)
    
    private let disposeBag = DisposeBag()
    
    func fetchUsersInfo(with username: String) -> Observable<[UserInfo]> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.usersRef.queryOrdered(byChild: "\(Constants.info)/\(Constants.username)")
                .queryStarting(atValue: username.lowercased())
                .queryEnding(atValue: username.lowercased() + "\u{f8ff}")
                .queryLimited(toFirst: 10)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let values = snapshot.value as? [String: Any] {
                        var usersInfo = [UserInfo]()
                        for userData in values.values {
                            if let user = userData as? [String: Any],
                                let info = user[Constants.info],
                                let userInfo = UserInfo(data: info) {
                                usersInfo.append(userInfo)
                            }
                        }
                        observer.onNext(usersInfo)
                        observer.onCompleted()
                    } else {
                        observer.onError(FIRError.parseError)
                    }
                }, withCancel: { (error) in
                    observer.onError(error)
                })
            
            return Disposables.create()
        })
    }
    
    func uploadUser(_ user: UserInfo, completion: @escaping (Result<UserInfo, Error>) -> ()) {
        usersRef.child(user.userId)
            .child(Constants.info)
            .setValue(user.toAny()) { (error, reference) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(user))
                }
        }
    }
    
    func uploadMessage(_ message: Message, from sender: Sender, to recipient: UserInfo, completion: ((String?, Error?) -> ())? = nil) {
        getChatId(sender: sender, recipient: recipient) { [weak self] (chatId, error) in
            if let error = error {
                completion?(nil, error)
            } else {
                let id = chatId ?? self?.chatsRef.childByAutoId().key ?? UUID().uuidString
                
                let messageRef = self?.chatsRef.child(id).child(Constants.messages).childByAutoId()
                let messageId = messageRef?.key ?? ""
                
                messageRef?.setValue(message.toAny())
                
                self?.usersRef.child(sender.id)
                    .child(Constants.chats)
                    .child(recipient.userId)
                    .child(Constants.info)
                    .setValue([
                        Constants.chatId: id,
                        Constants.companionId: recipient.userId
                    ])
                
                self?.usersRef.child(recipient.userId)
                    .child(Constants.chats)
                    .child(sender.id)
                    .child(Constants.info)
                    .setValue([
                        Constants.chatId: id,
                        Constants.companionId: sender.id
                    ])
                
                self?.usersRef.child(recipient.userId)
                    .child(Constants.newMessages)
                    .child(Constants.chats)
                    .child(id)
                    .child(Constants.messages)
                    .child(messageId)
                    .setValue([
                        Constants.messageId: messageId,
                        Constants.chatId: id,
                        Constants.senderId: sender.id
                    ])
                
                completion?(id, nil)
            }
        }
    }
    
    func fetchUsers(completion: @escaping ([UserInfo]) -> ()) {
        usersRef.observeSingleEvent(of: .value) { (userSnapshot) in
            if let values = userSnapshot.value as? [String: Any] {
                var users = [UserInfo]()
                for userData in values.values {
                    if let user = userData as? [String: Any],
                        let info = user[Constants.info],
                        let userInfo = UserInfo(data: info) {
                        users.append(userInfo)
                    }
                }
                completion(users)
            }
        }
    }
    
    func fetchUserInfo(userId: String, completion: @escaping (UserInfo) -> ()) {
        usersRef.child(userId).child(Constants.info)
            .observeSingleEvent(of: .value, with: { (userSnapshot) in
                completion(UserInfo(data: userSnapshot.value!)!)
        })
    }
    
    func getChatId(sender: Sender, recipient: UserInfo, completion: @escaping (String?, Error?) -> ()) {
        usersRef.child(sender.id)
            .child(Constants.chats)
            .child(recipient.userId)
            .child(Constants.info)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                let info = snapshot.value as? [String: Any]
                let chatId = info?[Constants.chatId] as? String
                completion(chatId, nil)
            }) { (error) in
                completion(nil, error)
        }
    }
    
    func observeChatId(sender: Sender, recipient: UserInfo, completion: @escaping (String?, Error?) -> ()) {
        usersRef.child(sender.id)
            .child(Constants.chats)
            .child(recipient.userId)
            .observeSingleEvent(of: .childAdded, with: { (snapshot) in
                let info = snapshot.value as? [String: Any]
                let chatId = info?[Constants.chatId] as? String
                completion(chatId, nil)
            }) { (error) in
                completion(nil, error)
        }
    }
    
    func fetchMessages(chatId: String, completion: @escaping ([Message]) -> ()) {
        chatsRef.child(chatId)
            .child(Constants.messages)
            .observe(.value) { (snapshot) in
                var messages = [Message]()
                if let values = snapshot.value as? [String: Any] {
                    for value in values {
                        let messageId = value.key
                        let message = Message(data: value.value, id: messageId)!
                        messages.append(message)
                    }
                }
                completion(messages)
            }
    }
    
    func fetchNewMessagesCount(user: UserInfo, completion: @escaping (UInt) -> ()) {
        usersRef.child(user.userId)
            .child(Constants.newMessages)
            .child(Constants.chats)
            .observe(.value) { (chatsSnapshot) in
                let chatsCount = chatsSnapshot.childrenCount
                completion(chatsCount)
        }
    }
    
    func fetchMessagesCount(chatId: String, user: UserInfo, completion: @escaping (UInt) -> ()) {
        usersRef.child(user.userId)
            .child(Constants.newMessages)
            .child(Constants.chats)
            .child(chatId)
            .child(Constants.messages)
            .observe(.value) { (snapshot) in
                completion(snapshot.childrenCount)
        }
    }
    
    func observeMessages(chatId: String,
                         sender: Sender,
                         recipient: UserInfo,
                         completion: @escaping (Message) -> ()) {
        usersRef.child(sender.id)
            .child(Constants.newMessages)
            .child(Constants.chats)
            .child(chatId)
            .child(Constants.messages)
            .observe(.childAdded) { (snapshot) in
                let value = snapshot.value as? [String: Any]
                let chatId = value?[Constants.chatId] as? String
                let messageId = value?[Constants.messageId] as? String
                //let senderId = value?[Constants.senderId] as? String
                
                self.chatsRef.child(chatId ?? "")
                    .child(Constants.messages)
                    .child(messageId ?? "")
                    .observeSingleEvent(of: .value) { (snapshot) in
                        let messageData = snapshot.value as Any
                        let message = Message(data: messageData, id: messageId ?? "")!
                        
                        completion(message)
                    }
            }
    }
    
    func observeChats(user: UserInfo, completion: @escaping ([Chat]) -> ()) {
        usersRef.child(user.userId)
            .child(Constants.chats)
            .observe(.value) { (snapshot) in
                var chats = [Chat]()
                if let values = snapshot.value as? [String: Any] {
                    for value in values {
                        let chat = Chat(data: value.value)!
                        chats.append(chat)
                    }
                    completion(chats)
                }
        }
    }
    
    func fetchLastMessage(chatId: String, completion: @escaping (Message) -> ()) {
        chatsRef.child(chatId)
            .child(Constants.messages)
            .queryOrdered(byChild: "date")
            .queryLimited(toLast: 1)
            .observe(.value) { (snapshot) in
                let messageSnapshot = (snapshot.value as? [String: Any])?.first
                let messageId = messageSnapshot?.key ?? ""
                let messageData = messageSnapshot?.value as Any
                let message = Message(data: messageData, id: messageId)!
                completion(message)
        }
    }
        
    func readMessage(_ message: Message, chatId: String, user: Sender) {
        usersRef.child(user.id)
            .child(Constants.newMessages)
            .child(Constants.chats)
            .child(chatId)
            .child(Constants.messages)
            .child(message.messageId)
            .removeValue()
        
        chatsRef.child(chatId)
            .child(Constants.messages)
            .child(message.messageId)
            .updateChildValues(["wasRead": true])
    }
    
    func removeObservers() {
        databaseRef.removeAllObservers()
    }
    
    deinit {
        removeObservers()
    }
    
//        func fetchMessages(sender: UserInfo, recipient: User) -> Observable<Message> {
//            return chatsRef.rx.observeEvent(.value).flatMapLatest({ (snapshot) -> Message in
//
//            })
//        }
}
