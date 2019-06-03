//
//  AuthService.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/16/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AuthServiceDelegate: class {
    func authService(_ authService: AuthService, didAuthorized user: UserInfo)
}

extension AuthServiceDelegate {
    func authService(_ authService: AuthService, didAuthorized user: UserInfo) { }
}

class AuthService {
    
    static let shared = AuthService()
    
    var currentUser = BehaviorRelay<UserInfo?>(value: nil)
    
    private(set) var user: UserInfo? {
        didSet {
            guard let user = user else { return }
            delegate?.authService(self, didAuthorized: user)
        }
    }
    
    var isUserAuthorized: Bool {
        return UserDefaults.standard.string(forKey: "userId") != nil
    }
    
    var userId: Observable<String?> {
        return UserDefaults.standard.rx.observe(String.self, "userId")
    }
    
    weak var delegate: AuthServiceDelegate?
    private let disposeBag = DisposeBag()
    
    private init() {
        userId.subscribe(onNext: { [weak self] (userId) in
            guard let id = userId else { return }
            self?.fetchUser(userId: id)
        }).disposed(by: disposeBag)
    }
    
    private func fetchUser(userId: String, completion: ((Result<UserInfo, Error>) -> Void)? = nil) {
        FIRDatabaseManager().fetchUserInfo(userId: userId) { [weak self] (user) in
            self?.currentUser.accept(user)
            self?.user = user
            completion?(.success(user))
        }
    }
    
    func login(userId: String) {
        UserDefaults.standard.set(userId, forKey: "userId")
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "userId")
        FIRAuth.logout()
    }
}
