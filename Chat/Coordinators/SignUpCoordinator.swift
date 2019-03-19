//
//  SignUpCoordinator.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/18/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class SignUpCoordinator: Coordinator {

    var signUpViewController: SignUpViewController?
    //lazy var signInViewModel = ResetPasswordViewModel()
    private let disposeBag = DisposeBag()
    
    func start(from viewController: UINavigationController) -> Observable<Void> {
        let signUpViewController = R.storyboard.auth.signUpViewController() 
        //signInViewController?.viewModel = signInViewModel
        
        viewController.pushViewController(signUpViewController!, animated: true)
        
        //        signInViewModel.doneAction.drive(onNext: { [unowned self] () in
        //            self.signInViewController?.dismiss(animated: true, completion: nil)
        //        }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    func coordinate(to coordinator: Coordinator, from viewController: UINavigationController) -> Observable<Void> {
        return coordinator.start(from: viewController)
    }
}
