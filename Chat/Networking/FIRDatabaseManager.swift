//
//  FIRDatabaseManager.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/16/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import FirebaseDatabase
import RxFirebaseDatabase
import RxSwift

enum FIRError: Error {
    case parseError
}

class FIRDatabaseManager {
    
    private let databaseRef = Database.database().reference()
    private lazy var usersRef = databaseRef.child("Users")
    private let disposeBag = DisposeBag()
    
    func fetchUsersInfo(with username: String) -> Observable<[UserInfo]> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            self?.usersRef.queryOrdered(byChild: "UserInfo/username")
                .queryStarting(atValue: username.lowercased())
                .queryEnding(atValue: username.lowercased() + "\u{f8ff}")
                .queryLimited(toFirst: 10)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let values = snapshot.value as? [String: Any] {
                        var usersInfo = [UserInfo]()
                        for userData in values.values {
                            if let user = userData as? [String: Any],
                                let info = user["UserInfo"],
                                let userInfo = UserInfo(data: info) {
                                usersInfo.append(userInfo)
                            }
                        }
                        observer.onNext(usersInfo)
                        observer.onCompleted()
                    } else {
                        observer.onError(FIRError.parseError)
                    }
                }, withCancel: { (error) in
                    observer.onError(error)
                })

            return Disposables.create()
        })
    }
    
    func uploadUser(_ user: UserInfo, completion: @escaping (Error?) -> ()) {
        usersRef.child(user.userId).child("UserInfo").setValue(user.toAny()) { (error, reference) in
            completion(error)
        }
    }
}
