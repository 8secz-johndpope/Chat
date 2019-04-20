//
//  ChatCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/19/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class ChatCoordinator: BaseCoordinator<Void> {
    
    private let recipient: UserInfo
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, recipient: UserInfo) {
        self.recipient = recipient
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let chatViewModel = ChatViewModel(recipient: recipient)
        let chatViewController = ChatViewController.create(with: chatViewModel)
        navigationController.pushViewController(chatViewController, animated: true)
        
        return Observable.never()
    }
}
