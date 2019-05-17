//
//  ProfileHeaderViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/16/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class ProfileHeaderViewModel {
    
    let profileImageUrl: Driver<URL?>
    let profileTitle: Driver<String?>
    
    private let profileImageUrlSubject = BehaviorSubject<URL?>(value: nil)
    private let profileTitleSubject = BehaviorSubject<String?>(value: nil)
    
    private let user = AuthService.shared.currentUser
    private let disposeBag = DisposeBag()
    
    init() {
        profileImageUrl = profileImageUrlSubject.asDriver(onErrorJustReturn: nil)
        profileTitle = profileTitleSubject.asDriver(onErrorJustReturn: nil)
        
        user.subscribe(onNext: { [weak self] (user) in
            self?.profileImageUrlSubject.onNext(user?.imageUrl)
            self?.profileTitleSubject.onNext(user?.username)
        }).disposed(by: disposeBag)
    }
}
