//
//  User.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/19/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import Foundation

class UserInfo {
    
    var email: String
    var imageUrl: String
    var userId: String
    var username: String
    
    init?(data: Any) {
        guard let info = data as? [String: Any],
            let email = info["email"] as? String,
            let imageUrl = info["imageUrl"] as? String,
            let userId = info["userId"] as? String,
            let username = info["username"] as? String else {
                return nil
        }
        
        self.email = email
        self.imageUrl = imageUrl
        self.userId = userId
        self.username = username
    }
    
    init(email: String, imageUrl: String, userId: String, username: String) {
        self.email = email
        self.imageUrl = imageUrl
        self.userId = userId
        self.username = username
    }
    
    func toAny() -> Any {
        return [
            "email": email,
            "imageUrl": imageUrl,
            "userId": userId,
            "username": username
        ]
    }
}
