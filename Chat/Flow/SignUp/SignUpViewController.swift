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
import NVActivityIndicatorView

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
        
        signUpButton.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let self = self else { return }
            let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0,
                                                                          y: 0,
                                                                          width: 40,
                                                                          height: 40),
                                                            type: .circleStrokeSpin)
            activityIndicator.startAnimating()
            self.view.showToast(text: "loading...", view: activityIndicator)
            }.disposed(by: disposeBag)
        
        viewModel.output.errorsObservable
            .subscribe(onNext: { [weak self] (error) in
                guard let self = self else { return }
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                imageView.image = UIImage(named: "error")
                imageView.contentMode = .scaleAspectFit
                self.view.showToast(text: "error", view: imageView, duration: 2)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureTextFields() {
        usernameTextFieldController = MDCTextInputControllerUnderline(textInput: usernameTextField)
        emailTextFieldController = MDCTextInputControllerUnderline(textInput: emailTextField)
        passwordTextFieldController = MDCTextInputControllerUnderline(textInput: passwordTextField)
    }
}

extension SignUpViewController {
    
    static func create(with viewModel: SignUpViewModel) -> SignUpViewController {
        let viewController = R.storyboard.auth.signUpViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
