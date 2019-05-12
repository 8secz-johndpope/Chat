//
//  ContactCellViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/12/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa

class ContactCellViewModel {
    
    var contactImageUrl: Driver<URL?>
    var contactTitle: Driver<String>
    
    private let contact: UserInfo
    
    init(contact: UserInfo) {
        self.contact = contact
        self.contactImageUrl = Driver.just(contact.imageUrl)
        self.contactTitle = Driver.just(contact.username)
    }
}
