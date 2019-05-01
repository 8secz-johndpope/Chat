//
//  ViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/14/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import MaterialComponents
import NVActivityIndicatorView
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
        
        signInButton.rx.tap.asObservable().subscribe { [weak self] (_) in
            self?.showLoadingToast()
        }.disposed(by: disposeBag)
        
        resetPasswordButton.rx.tap
            .subscribe(viewModel.input.resetPasswordDidTap)
            .disposed(by: disposeBag)
        
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func showLoadingToast() {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                        type: .circleStrokeSpin)
        activityIndicator.startAnimating()
        self.view.showToast(text: "loading...", view: activityIndicator)
    }
    
    private func configureTextFields() {
        usernameTextFieldController = MDCTextInputControllerUnderline(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerUnderline(textInput: passwordTextField)
    }
    
}

extension SignInViewController {
    
    static func create(with viewModel: SignInViewModel) -> SignInViewController {
        let viewController = R.storyboard.auth.signInViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
