//
//  ViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/14/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import MaterialComponents
import RxSwift
import RxCocoa
import Rswift

class SignInViewController: UIViewController {
    
    //MARK: UI
    @IBOutlet var usernameTextField: MDCTextField!
    @IBOutlet var passwordTextField: MDCTextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var resetPasswordButton: UIButton!
    
    //MARK: Properties
    var viewModel: SignInViewModel!
    let displayCompletion = PublishSubject<Void>()
    private var usernameTextFieldController: MDCTextInputControllerUnderline!
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
        usernameTextField.rx.text.orEmpty.asObservable()
            .subscribe(viewModel.input.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.asObservable()
            .subscribe(viewModel.input.password)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap.asObservable()
            .subscribe(viewModel.input.signInDidTap)
            .disposed(by: disposeBag)
        
        resetPasswordButton.rx.tap
            .subscribe(viewModel.input.resetPasswordDidTap)
            .disposed(by: disposeBag)
        
        viewModel.output.resultObservable
            .subscribe(onNext: { [weak self] (user) in
                self?.showAlert(with: "Signed in")
            })
            .disposed(by: disposeBag)
        
        viewModel.output.errorsObservable
            .subscribe(onNext: { [weak self] (error) in
                self?.showAlert(with: "Error")
            })
            .disposed(by: disposeBag)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func configureTextFields() {
        usernameTextFieldController = MDCTextInputControllerUnderline(textInput: usernameTextField)
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

extension SignInViewController {
    
    static func create(with viewModel: SignInViewModel) -> SignInViewController {
        let viewController = R.storyboard.auth.signInViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
