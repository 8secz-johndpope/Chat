//
//  SearchContactsViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/16/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

enum ContactTableViewCellType {
    case normal(userInfo: UserInfo)
    case error(message: String)
    case empty
}

class SearchContactsViewModel: ViewModelProtocol {
    
    struct Input {
        let searchBarText = BehaviorSubject<String>(value: "")
        let selection: AnyObserver<UserInfo>
    }
    
    struct Output {
        let selectionObservable: Observable<UserInfo>
        let usersInfoObservable: Observable<[UserInfo]>
        let isLoading: Observable<Bool>
    }
    
    let input: Input
    let output: Output
    
    private let searchBarTextSubject = PublishSubject<String>()
    private let selectionSubject = PublishSubject<UserInfo>()
    private let errorSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    private let loadInProgress = BehaviorRelay(value: false)
    private var usersInfo = BehaviorRelay<[UserInfo]>(value: [])
    private var databaseManager = FIRDatabaseManager()
    
    init() {
        self.input = Input(selection: selectionSubject.asObserver())
        self.output = Output(selectionObservable: selectionSubject.asObservable(),
                             usersInfoObservable: usersInfo.asObservable(),
                             isLoading: loadInProgress.asObservable().distinctUntilChanged())
        
        input.searchBarText.asObservable()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] (text) -> Observable<[UserInfo]> in
                guard let self = self else { return Observable.empty() }
                self.loadInProgress.accept(true)
                return self.databaseManager.fetchUsersInfo(with: text)
                    .retry(3)
                    .startWith([])
                    .catchErrorJustReturn([])
            }
            .subscribe(onNext: { [weak self] (usersInfo) in
                self?.loadInProgress.accept(false)
                self?.usersInfo.accept(usersInfo)
            })
            .disposed(by: disposeBag)
        
    }

}
