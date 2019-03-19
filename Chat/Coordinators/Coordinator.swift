//
//  Coordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

protocol Coordinator {
    func start(from viewController: UINavigationController) -> Observable<Void>
    func coordinate(to coordinator: Coordinator, from viewController: UINavigationController) -> Observable<Void>
}
