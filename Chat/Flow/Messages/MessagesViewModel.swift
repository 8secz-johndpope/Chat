//
//  MessagesViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift

class MessagesViewModel: BaseCoordinator<Void> {
    
    override func start() -> Observable<Void> {
        return Observable.never()
    }
}
