//
//  ResetPasswordViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/17/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MaterialComponents.MaterialTextFields

class ResetPasswordViewController: UIViewController {
    
    //MARK: UI
    @IBOutlet var emailTextField: MDCTextField!
    @IBOutlet var resetButton: UIButton!
    
    //MARK: Properties
    var viewModel: ResetPasswordViewModel!
    var displayCompletion = PublishSubject<Void>()
    private var emailTextFieldController: MDCTextInputControllerUnderline!
    private let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField()
        configureViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent{ displayCompletion.onCompleted() }
    }
    
    //MARK: Methods
    func configureViewModel() {
        emailTextField.rx.text.orEmpty
            .subscribe(viewModel.input.email)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .subscribe(viewModel.input.resetDidTap)
            .disposed(by: disposeBag)
        
        viewModel.output.resultSubject
            .subscribe(onNext: { [weak self] (error) in
                self?.showAlert(with: "Success. Check your email.")
            })
            .disposed(by: disposeBag)
        
        viewModel.output.errorObservable
            .subscribe(onNext: { [weak self] (error) in
                self?.showAlert(with: "Error. Email isn't correct.")
            })
            .disposed(by: disposeBag)
        
//        let input = ResetPasswordViewModel.Input(email: emailTextField.rx.text.orEmpty.asDriver(),
//                                                 resetDidTap: resetButton.rx.tap.asDriver())
//        let output = viewModel.transform(input: input)
//        
//        output.resultSubject
//            .subscribe(onNext: { [weak self] (error) in
//                self?.showAlert(with: "Success. Check your email.")
//            })
//            .disposed(by: disposeBag)
//        
//        output.errorObservable
//            .subscribe(onNext: { [weak self] (error) in
//                self?.showAlert(with: "Error. Email isn't correct.")
//            })
//            .disposed(by: disposeBag)
    }
    
    private func configureTextField() {
        emailTextFieldController = MDCTextInputControllerUnderline(textInput: emailTextField)
    }

    private func showAlert(with message: String) {
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ResetPasswordViewController {
    
    static func create(with viewModel: ResetPasswordViewModel) -> ResetPasswordViewController {
        let viewController = R.storyboard.auth.resetPasswordViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
