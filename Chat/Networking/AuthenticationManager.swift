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
    case unknownError
}

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    var user = Auth.auth().currentUser
    
    private init() {}
    
    func login() {
        UserDefaults.standard.set(true, forKey: "authorized")
    }
    
    func userIsAuthorized() -> Bool {
        return UserDefaults.standard.bool(forKey: "authorized")
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "authorized")
    }
    
    func sendCode(to phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let id = verificationID {
                    UserDefaults.standard.set(id, forKey: "authVerificationID")
                    completion(.success(id))
                } else {
                    completion(.failure(error ?? AuthError.unknownError))
                }
            }
    }
    
    func verifyPhoneNumber(verificationId: String,
                           verificationCode: String,
                           completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId,
                                                                 verificationCode: verificationCode)
        Auth.auth().signInAndRetrieveData(with: credential) { (authDataResult, error) in
            if let authData = authDataResult {
                completion(.success(authData))
            } else {
                completion(.failure(error ?? AuthError.unknownError))
            }
        }
    }
}
