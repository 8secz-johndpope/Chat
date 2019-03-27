//
//  AuthenticationService.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/24/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import FirebaseAuth

protocol AuthenticationServiceProtocol {
    
}

class AuthenticationService: AuthenticationServiceProtocol {
   
    static func signIn(with email: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
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
    
    static func signUp(with email: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
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
    
    static func sendPasswordReset(with email: String) -> Observable<Any> {
        return Observable.create({ observer in
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
}
