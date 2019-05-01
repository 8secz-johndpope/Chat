//
//  Chat.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/28/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import Foundation

class Chat {
    
    var id: String
    var companionId: String
    
    init?(data: Any) {
        guard let value = data as? [String: Any],
            let info = value["info"] as? [String: Any],
            let chatId = info["chatId"] as? String,
            let companionId = info["companionId"] as? String else {
                return nil
        }
        
        self.id = chatId
        self.companionId = companionId
    }
}
