//
//  MessagesViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class MessagesViewModel: ViewModelProtocol {
    
    struct Input {
        let searchBarText = BehaviorSubject<String>(value: "")
        let selection: AnyObserver<Chat>
    }
    
    struct Output {
        let selectionObservable: Observable<Chat>
        let chatsObservable: Observable<[Chat]>
        let fetchCompanionObservable: Observable<UserInfo>
        let chatsCountWithNewMessages = BehaviorRelay<UInt>(value: 0)
    }
    
    let input: Input
    let output: Output
    
    private let user = AuthService.shared.currentUser
    private let chats = BehaviorRelay<[Chat]>(value: [])
    private let selectionSubject = PublishSubject<Chat>()
    private let fetchCompanionSubject = PublishSubject<UserInfo>()
    private let firDatabse = FIRDatabaseManager()
    private let disposeBag = DisposeBag()
    
    init() {
        self.input = Input(selection: selectionSubject.asObserver())
        self.output = Output(selectionObservable: selectionSubject.asObservable(),
                             chatsObservable: chats.asObservable(),
                             fetchCompanionObservable: fetchCompanionSubject.asObservable())
        
        user.subscribe(onNext: { [weak self] (user) in
            guard let user = user else { return }
            self?.fethcChats(user: user)
            self?.fetchNewMessaggesCount(user: user)
        }).disposed(by: disposeBag)

        output.selectionObservable.subscribe(onNext: { [weak self] (chat) in
            self?.fetchCompanion(with: chat.companionId)
        }).disposed(by: disposeBag)
    }
    
    private func fethcChats(user: UserInfo) {
        self.firDatabse.observeChats(user: user, completion: { (chats) in
            self.chats.accept(chats)
        })
    }
    
    private func fetchNewMessaggesCount(user: UserInfo) {
        firDatabse.fetchNewMessagesCount(user: user) { [weak self] (chatsCount) in
            self?.output.chatsCountWithNewMessages.accept(chatsCount)
        }
    }
    
    private func fetchCompanion(with companionId: String) {
        firDatabse.fetchUserInfo(userId: companionId) { [weak self] (userInfo) in
            self?.fetchCompanionSubject.onNext(userInfo)
        }
    }
}
