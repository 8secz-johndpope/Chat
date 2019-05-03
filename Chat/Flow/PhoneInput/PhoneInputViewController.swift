//
//  PhoneInputViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/2/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class PhoneInputViewController: UIViewController {
    
    @IBOutlet var phoneCodeTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var verifyButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var countryFlagButton: UIButton!
    
    private var viewModel: PhoneInputViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNotifications()
        configureViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureUI() {
        phoneCodeTextField.text = "+"
        phoneCodeTextField.becomeFirstResponder()
        phoneCodeTextField.delegate = self
    }
    
    private func configureViewModel() {
        cancelButton.rx.tap
            .subscribe(viewModel.input.cancelButtonDidTap)
            .disposed(by: disposeBag)
        
        verifyButton.rx.tap
            .subscribe(viewModel.input.verifyButtonDidTap)
            .disposed(by: disposeBag)
        
        countryFlagButton.rx.tap
            .subscribe(viewModel.input.countryFlagButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                let height = keyboardSize.height
                
                verifyButton.translatesAutoresizingMaskIntoConstraints = false
                verifyButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                verifyButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                verifyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -height).isActive = true
                verifyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                view.layoutIfNeeded()
            }
        }
        
    }
    
}

extension PhoneInputViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.text == "+" && string == "" { return false }
        
        return textField.text?.count ?? 0 < 4 || string == ""
    }
}

extension PhoneInputViewController {
    
    static func create(with viewModel: PhoneInputViewModel) -> PhoneInputViewController {
        let viewController = R.storyboard.auth.phoneInputViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
