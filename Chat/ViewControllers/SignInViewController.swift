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

class SignInViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet var usernameTextField: UnderLineTextField!
    @IBOutlet var passwordTextField: UnderLineTextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var resetPasswordButton: UIButton!
    
    var viewModel: SignInViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupBindings()
    }
    
    private func setupBindings() {
        signInButton.rx
            .tap
            .bind(to: viewModel.signInActionObserver)
            .disposed(by: disposeBag)
        
        resetPasswordButton.rx
            .tap
            .bind(to: viewModel.resetPasswordActionObserver)
            .disposed(by: disposeBag)
        
        signUpButton.rx
            .tap
            .bind(to: viewModel.signUpActionObserver)
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
