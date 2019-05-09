//
//  ContactsViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa
import Contacts
import PhoneNumberKit

class ContactsViewModel: ViewModelProtocol {
    
    struct Input {
        let addContactButtonDidTap: AnyObserver<Void>
        let selection: AnyObserver<UserInfo>
    }
    
    struct Output {
        let addContactButtonObservable: Observable<Void>
        let contacts: Driver<[UserInfo]>
        let contactSelected: Observable<UserInfo>
    }
    
    let input: Input
    let output: Output
    var contacts: [Contact] = []
    private let firDatabase = FIRDatabaseManager()
    private let selectionSubject = PublishSubject<UserInfo>()
    private let contactsSubject = PublishSubject<[UserInfo]>()
    private let addContactButtonSubject = PublishSubject<Void>()
    
    init() {
        self.input = Input(addContactButtonDidTap: addContactButtonSubject.asObserver(),
                           selection: selectionSubject.asObserver())
        self.output = Output(addContactButtonObservable: addContactButtonSubject.asObservable(),
                             contacts: contactsSubject.asDriver(onErrorJustReturn: []),
                             contactSelected: selectionSubject.asObservable())
        self.loadContacts()
    }
    
    private func loadContacts() {
        let contactStore = CNContactStore()
        var contacts = [Contact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPhoneNumbersKey,
                    CNContactImageDataKey,
                    CNContactThumbnailImageDataKey] as! [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                contacts.append(Contact(contact: contact))
            }
        }
        catch {
            print("unable to fetch contacts")
        }

        let contactsNumbers = PhoneNumberKit().parse(contacts.map { $0.phoneNumbers }.flatMap { $0 })
        let formattedNumbers = contactsNumbers.map { PhoneNumberKit().format($0, toType: .e164) }
        firDatabase.fetchUsers { [weak self] (users) in
            let filteredUsers = users.filter { formattedNumbers.contains($0.phoneNumber) }
            self?.contactsSubject.onNext(filteredUsers)
        }
    }
}
