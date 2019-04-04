//
//  MessagesViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {

    var viewModel: MessagesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension MessagesTableViewController {
    
    static func create(with viewModel: MessagesViewModel) -> MessagesTableViewController {
        let viewController = R.storyboard.main.messagesTableViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
