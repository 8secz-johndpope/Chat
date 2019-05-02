//
//  HomeViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/24/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    //MARK: UI
    @IBOutlet var startMessagingButton: UIButton!
    
    //MARK: Properties
    var viewModel: HomeViewModel!
    let displayCompletion = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent { displayCompletion.onCompleted() }
    }

    //MARK: Methods
    private func configureViewModel() {
        startMessagingButton.rx.tap
            .subscribe(viewModel.input.startMessaging)
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let viewController = R.storyboard.auth.homeViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
