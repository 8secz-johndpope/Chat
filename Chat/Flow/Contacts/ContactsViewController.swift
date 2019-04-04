//
//  ContactsViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    var viewModel: ContactsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ContactsViewController {
    
    static func create(with viewModel: ContactsViewModel) -> ContactsViewController {
        let viewController = R.storyboard.main.contactsViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
