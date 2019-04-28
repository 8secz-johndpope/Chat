//
//  AuthenticationManager.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/27/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import FirebaseAuth
import RxFirebaseAuthentication
import RxSwift

struct Credential {
    var email: String
    var password: String
}

enum AuthError: Error {
    case credentialsMissing
}

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    var user: User?
    
    private init() {}
    
    private func saveCredentials(withEmail email: String, password: String) {
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(true, forKey: "authorized")
    }
    
    private func loadCredentials() -> Credential? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,
            let password = UserDefaults.standard.value(forKey: "password") as? String else {
                return nil
        }
        
        return Credential(email: email, password: password)
    }
    
    func wasAuthorized() -> Bool {
        return UserDefaults.standard.value(forKey: "authorized") as? Bool == true
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.set(false, forKey: "authorized")
    }
    
    func signIn() -> Observable<Event<AuthDataResult>> {
        guard let credential = loadCredentials() else {
            return Observable.error(AuthError.credentialsMissing)
        }
        return signIn(withEmail: credential.email, password: credential.password)
    }
    
    func signIn(withEmail email: String, password: String) -> Observable<Event<AuthDataResult>> {
        return Auth.auth().rx
            .signIn(withEmail: email, password: password)
            .do(onNext: { [weak self] (authDataResult) in
                self?.saveCredentials(withEmail: email, password: password)
                self?.user = authDataResult.user
            }).materialize()
    }
    
    func createUser(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        return Auth.auth().rx.createUser(withEmail: email, password: password)
    }
    
    func sendPasswordReset(withEmail email: String) -> Observable<Event<Void>> {
        return Auth.auth().rx.sendPasswordReset(withEmail: email).materialize()
    }
}
