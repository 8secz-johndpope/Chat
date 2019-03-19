//
//  AppCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AppCoordinator: Coordinator {
    
    lazy var signInCoordinator = SignInCoordinator()
    private let disposeBag = DisposeBag()
    
    func start(from viewController: UINavigationController) -> Observable<Void> {
        viewController.rx.viewDidAppear.bind(onNext: { [unowned self] () in
            _ = self.coordinate(to: self.signInCoordinator, from: viewController)
        }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    func coordinate(to coordinator: Coordinator, from viewController: UINavigationController) -> Observable<Void> {
        return coordinator.start(from: viewController)
    }
    
}

extension Reactive where Base: UIViewController {
    
    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map { _ in })
    }
    
    var viewWillAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillAppear))
    }
    
    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidAppear))
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillDisappear))
    }
    
    var viewDidDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidDisappear))
    }
    
}
