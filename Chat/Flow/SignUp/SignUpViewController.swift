//
//  SignUpViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/17/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MaterialComponents.MaterialTextFields

class SignUpViewController: UIViewController {
    
    //MARK: UI
    @IBOutlet var usernameTextField: MDCTextField!
    @IBOutlet var emailTextField: MDCTextField!
    @IBOutlet var passwordTextField: MDCTextField!
    @IBOutlet var signUpButton: UIButton!
    
    //MARK: Properties
    var viewModel: SignUpViewModel!
    let displayCompletion = PublishSubject<Void>()
    private var usernameTextFieldController: MDCTextInputControllerUnderline!
    private var emailTextFieldController: MDCTextInputControllerUnderline!
    private var passwordTextFieldController: MDCTextInputControllerUnderline!
    private let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
        configureViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent { displayCompletion.onCompleted() }
    }
    
    //MARK: Methods
    func configureViewModel() {
        usernameTextField.rx.text.orEmpty
            .subscribe(viewModel.input.username)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .subscribe(viewModel.input.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .subscribe(viewModel.input.password)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(viewModel.input.signUpDidTap)
            .disposed(by: disposeBag)
        
        viewModel.output.resultObservable
            .subscribe(onNext: { [unowned self] (user) in
                self.showAlert(with: "Success")
            })
            .disposed(by: disposeBag)
        
        viewModel.output.errorsObservable
            .subscribe(onNext: { [unowned self] (error) in
                self.showAlert(with: "Error")
            })
            .disposed(by: disposeBag)
    }
    
    private func configureTextFields() {
        usernameTextFieldController = MDCTextInputControllerUnderline(textInput: usernameTextField)
        emailTextFieldController = MDCTextInputControllerUnderline(textInput: emailTextField)
        passwordTextFieldController = MDCTextInputControllerUnderline(textInput: passwordTextField)
    }
    
    private func showAlert(with message: String) {
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SignUpViewController {
    
    static func create(with viewModel: SignUpViewModel) -> SignUpViewController {
        let viewController = R.storyboard.auth.signUpViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
