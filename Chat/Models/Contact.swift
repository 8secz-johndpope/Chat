//
//  Contact.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/10/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import Foundation
import Contacts

struct Contact {
    
    var username: String
    var phoneNumbers: [String]
    var imageData: Data?
    
    init(contact: CNContact) {
        self.username = "\(contact.givenName) \(contact.familyName)"
        self.imageData = contact.imageData
        self.phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }
    }
}
