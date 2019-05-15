//
//  ContactResultsViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/12/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class ContactResultsViewModel: ViewModelProtocol {
    
    struct Input {
        let selection: AnyObserver<UserInfo>
        let searchBarText = BehaviorSubject<String>(value: "")
    }
    
    struct Output {
        let contacts: Driver<[UserInfo]>
        let contactSelected: Observable<UserInfo>
    }
    
    let input: Input
    let output: Output
    
    private let searchBarTextSubject = PublishSubject<String>()
    private let selectionSubject = PublishSubject<UserInfo>()
    private let contactsSubject = PublishSubject<[UserInfo]>()
    private let disposeBag = DisposeBag()
    private let firDatabase = FIRDatabaseManager()
    private let user = AuthenticationManager.shared.user!
    
    init() {        
        self.input = Input(selection: selectionSubject.asObserver())
        self.output = Output(contacts: contactsSubject.asDriver(onErrorJustReturn: []),
                             contactSelected: selectionSubject.asObservable())
        
        input.searchBarText.asObservable()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .flatMapLatest { [weak self] (text) -> Observable<[UserInfo]> in
                guard let self = self else { return Observable.empty() }
                return self.firDatabase.fetchUsersInfo(with: text)
                    .retry(3)
                    .startWith([])
                    .catchErrorJustReturn([])
            }
            .subscribe(onNext: { [weak self] (usersInfo) in
                let filteredContacts = usersInfo.filter { $0.userId != self?.user.uid }
                self?.contactsSubject.onNext(filteredContacts)
            })
            .disposed(by: disposeBag)
    }
    
    func clearPreviousResults() {
        contactsSubject.onNext([])
    }
}
