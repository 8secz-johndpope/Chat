//
//  LoginService.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/19/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import FirebaseAuth

struct Credentials {
    let username: String
    let password: String
}

protocol AuthenticationServiceProtocol {
    func createUser(with credentials: Credentials) -> Observable<User>
    func signIn(with credentials: Credentials) -> Observable<User>
}

class AuthenticationService: AuthenticationServiceProtocol {
    
    func createUser(with credentials: Credentials) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: credentials.username, password: credentials.password) { authResult, error in
                if let error = error {
                    observer.onError(error)
                } else if let user = authResult?.user {
                    observer.onNext(user)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func signIn(with credentials: Credentials) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: credentials.username, password: credentials.password) { authResult, error in
                if let error = error {
                    observer.onError(error)
                } else if let user = authResult?.user {
                    observer.onNext(user)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
