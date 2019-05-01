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
        let fetchChats: AnyObserver<Void>
        let selection: AnyObserver<Chat>
    }
    
    struct Output {
        let selectionObservable: Observable<Chat>
        let chatsObservable: Observable<[Chat]>
        let fetchCompanionObservable: Observable<UserInfo>
    }
    
    let input: Input
    let output: Output
    
    private let user = AuthenticationManager.shared.user!
    private let chats = BehaviorRelay<[Chat]>(value: [])
    private let fetchChatsSubject = PublishSubject<Void>()
    private let selectionSubject = PublishSubject<Chat>()
    private let fetchCompanionSubject = PublishSubject<UserInfo>()
    private let firDatabse = FIRDatabaseManager()
    private let disposeBag = DisposeBag()
    
    init() {
        self.input = Input(fetchChats: fetchChatsSubject.asObserver(),
                           selection: selectionSubject.asObserver())
        self.output = Output(selectionObservable: selectionSubject.asObservable(),
                             chatsObservable: chats.asObservable(),
                             fetchCompanionObservable: fetchCompanionSubject.asObservable())
        
        fetchChatsSubject.asObservable().subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.firDatabse.observeChats(user: self.user, completion: { (chats) in
                self.chats.accept(chats)
            })
        }).disposed(by: disposeBag)
        
        output.selectionObservable.subscribe(onNext: { [weak self] (chat) in
            self?.fetchCompanion(with: chat.companionId)
        }).disposed(by: disposeBag)
    }
    
    private func fetchCompanion(with companionId: String) {
        firDatabse.fetchUserInfo(userId: companionId) { [weak self] (userInfo) in
            self?.fetchCompanionSubject.onNext(userInfo)
        }
    }
}
