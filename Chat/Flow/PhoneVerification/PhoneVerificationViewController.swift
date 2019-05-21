//
//  PhoneVerificationViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/2/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class PhoneVerificationViewController: UIViewController {

    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var resendCodeButton: UIButton!
    @IBOutlet var resendCodeButtonBottomAnchor: NSLayoutConstraint!
    
    private var viewModel: PhoneVerificationViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureUI()
    }
    
    private func configureUI() {
        textFields[0].becomeFirstResponder()
        
        for textField in textFields {
            textField.tintAdjustmentMode = .dimmed
            textField.layer.shadowColor = UIColor.clear.cgColor
            textField.layer.shadowOpacity = 0.6
            textField.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
            textField.layer.shadowRadius = 5
            textField.rx.controlEvent([.editingChanged])
                .subscribe(onNext: { [weak self] (_) in
                    textField.backgroundColor = textField.text == "" ? .silver : .black
                    let nextTextField = self?.textFields.filter { $0.text == "" }.first
                    if textField.text != "" {
                        nextTextField?.becomeFirstResponder()
                    }
                    if nextTextField == nil {
                        let code = self?.textFields.compactMap { $0.text }.joined(separator: "") ?? ""
                        self?.viewModel.sendCode(code)
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func configureViewModel() {
        backButton.rx.tap
            .subscribe(viewModel.input.backButtonDidTap)
            .disposed(by: disposeBag)
        
        viewModel.output.isUpdating.subscribe(onNext: { [weak self] isUpdating in
            isUpdating ? self?.showUpdatingToast() : self?.hideToast()
        }).disposed(by: disposeBag)
        
        viewModel.output.isError.subscribe(onNext: { [weak self] error in
            self?.showErrorToast(error: error)
        }).disposed(by: disposeBag)
        
        keyboardHeight.subscribe(onNext: { [weak self] (keyboardHeight) in
            let safeAreaBottomConstant = self?.view.safeAreaInsets.bottom ?? 0.0
            let buttonIndent: CGFloat = 12.0
            let isKeyboardWillShow = keyboardHeight > 0
            let bottomHeightConstant = isKeyboardWillShow ?
                keyboardHeight + buttonIndent :
                safeAreaBottomConstant + buttonIndent
            
            self?.resendCodeButtonBottomAnchor.constant = bottomHeightConstant
            //self?.view.layoutIfNeeded()
        }).disposed(by: disposeBag)
    }
    
}

extension PhoneVerificationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //textField.text = ""
        //textField.backgroundColor = .silver
        textField.layer.shadowColor = UIColor.black.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.shadowColor = UIColor.clear.cgColor
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        for (index, codeTextField) in textFields.enumerated(){
            if textField.text == "", string == "", textField === codeTextField {
                textField.resignFirstResponder()
                let previousTextField = textField === textFields.first ? textFields.last : textFields[index - 1]
                previousTextField?.becomeFirstResponder()
                return false
            }
        }
        return textField.text?.count ?? 0 < 1 || (textField.text?.count == 1 && string == "")
    }
    
}

extension PhoneVerificationViewController {
    
    static func create(with viewModel: PhoneVerificationViewModel) -> PhoneVerificationViewController {
        let viewController = R.storyboard.auth.phoneVerificationViewController()!
        viewController.viewModel = viewModel
        viewController.title = viewModel.phoneNumber
        
        return viewController
    }
    
}

extension UIColor {
    static let silver = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0)
}
