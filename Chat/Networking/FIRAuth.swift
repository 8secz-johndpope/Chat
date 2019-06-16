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
    case userIdMissing
}

class FIRAuth {
    
    static func logout() {
        try? Auth.auth().signOut()
    }
    
    static func sendCode(to phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
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
    
    static func verifyPhoneNumber(verificationId: String,
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
