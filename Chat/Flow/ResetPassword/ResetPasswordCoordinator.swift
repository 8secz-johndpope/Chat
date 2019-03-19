//
//  ResetPasswordCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class ResetPasswordCoordinator: Coordinator {

    var resetPasswordViewController: ResetPasswordViewController?
    //lazy var signInViewModel = ResetPasswordViewModel()
    private let disposeBag = DisposeBag()
    
    func start(from navigationController: UINavigationController) -> Observable<Void> {
        let resetPasswordViewController = R.storyboard.auth.resetPasswordViewController()
        //signInViewController?.viewModel = signInViewModel
        
        navigationController.pushViewController(resetPasswordViewController!, animated: true)
        
//        signInViewModel.doneAction.drive(onNext: { [unowned self] () in
//            self.signInViewController?.dismiss(animated: true, completion: nil)
//        }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    func coordinate(to coordinator: Coordinator, from viewController: UINavigationController) -> Observable<Void> {
        return coordinator.start(from: viewController)
    }
    
}
