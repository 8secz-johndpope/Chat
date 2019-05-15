//
//  MainTabBarController.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/30/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class MainTabBarController: UITabBarController {

    private var viewModel: MainTabBarViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureViewModel()
    }
    
    private func configureUI() {
        modalTransitionStyle = .coverVertical
    }
    
    private func configureViewModel() {
        viewModel.chatsCountWithNewMessages.asDriver()
            .drive(onNext: { [weak self] (count) in
                let viewController = self?.viewControllers?
                    .compactMap { ($0 as? UINavigationController)?.topViewController }
                    .filter({ $0 is MessagesTableViewController })
                    .first
                viewController?.tabBarItem.badgeValue = count == 0 ? nil : String(count)
                UIApplication.shared.applicationIconBadgeNumber = Int(count)
            })
            .disposed(by: disposeBag)
    }
}

extension MainTabBarController {
    
    static func create(with viewModel: MainTabBarViewModel) -> MainTabBarController {
        let tabBarController = R.storyboard.main.mainTabBarController()!
        tabBarController.viewModel = viewModel
        return tabBarController
    }
    
}
