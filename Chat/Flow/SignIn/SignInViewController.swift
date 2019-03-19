//
//  ViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/14/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import UnderLineTextField
import RxSwift
import RxCocoa
import Rswift

class SignInViewController: UIViewController, ControllerType {
    
    typealias ViewModelType = SignInViewModel
    
    //MARK: Properties
    var viewModel: ViewModelType!
    
    //MARK: UI
    @IBOutlet var usernameTextField: UnderLineTextField!
    @IBOutlet var passwordTextField: UnderLineTextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var resetPasswordButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        configureViewModel()
    }
    
    //MARK: Methods
    func configureViewModel() {
        usernameTextField.rx.text.orEmpty.asObservable()
            .subscribe(viewModel.input.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.asObservable()
            .subscribe(viewModel.input.password)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap.asObservable()
            .subscribe(viewModel.input.signInDidTap)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(viewModel.input.signUpDidTap)
            .disposed(by: disposeBag)
        
        resetPasswordButton.rx.tap
            .subscribe(viewModel.input.resetPasswordDidTap)
            .disposed(by: disposeBag)
        
        viewModel.output.resultObservable
            .subscribe(onNext: { (user) in
                print("Signed in")
            })
            .disposed(by: disposeBag)
        
        viewModel.output.errorsObservable
            .subscribe(onNext: { (error) in
                print("Error")
            })
            .disposed(by: disposeBag)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func textFieldDidBeginEditing(_ sender: UnderLineTextField) {
        sender.contentStatus = .filled
        sender.tintColor = sender.activeLineColor
        sender.activePlaceholderTextColor = sender.activeLineColor
    }
    
    @IBAction func textFieldChanged(_ sender: UnderLineTextField) {
        if sender.text?.count == 0 { sender.contentStatus = .filled }
    }
    
    @IBAction func textFieldDidEndEditing(_ sender: UnderLineTextField) {
        if sender.text?.count == 0 { sender.contentStatus = .empty }
        
        sender.activePlaceholderTextColor = sender.inactiveLineColor
    }
    
}

extension SignInViewController {
    
    static func create(with viewModel: SignInViewModel) -> UIViewController {
        let viewController = R.storyboard.auth.signInViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
