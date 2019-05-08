//
//  PhoneInputViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/2/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PhoneNumberKit

class PhoneInputViewController: UIViewController {
    
    @IBOutlet var phoneNumberTextField: PhoneNumberTextField!
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureUI() {
        phoneNumberTextField.text = "+"
        phoneNumberTextField.becomeFirstResponder()
        phoneNumberTextField.delegate = self
        
        phoneNumberTextField.clearButtonMode = .never
        phoneNumberTextField.textAlignment = .center
        phoneNumberTextField.font = UIFont.systemFont(ofSize: 22)

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
        
        viewModel.output
            .countryFlag
            .drive(countryFlagButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        phoneNumberTextField.rx.controlEvent([.editingChanged])
            .flatMap { _ -> Observable<String> in
                return Observable.just(self.phoneNumberTextField.region)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        phoneNumberTextField.rx.text.orEmpty
            .flatMap { _ -> Observable<String> in Observable.just(self.phoneNumberTextField.region ) }
            .subscribe(viewModel.input.region)
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
        return !(textField.text == "+" && string == "") && ((textField.text?.count ?? 0) < 18 || string == "")
    }
}

extension PhoneInputViewController {
    
    static func create(with viewModel: PhoneInputViewModel) -> PhoneInputViewController {
        let viewController = R.storyboard.auth.phoneInputViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}

extension PhoneNumberTextField {
    var region: String {
        get {
            if (text?.count ?? 0) > 1 {
                return (currentRegion == "US" && text?[1] != "1") ? "" : currentRegion
            }
            return ""
        }
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

/*extension Reactive where Base: PhoneNumberTextField {
 
 var currentRegion: ControlProperty<String> {
 return base.rx.controlProperty(
 editingEvents: UIControlEvents.valueChanged,
 getter: { $0.currentRegion },
 setter: { _,_ in  }
 )
 }
 
 var nationalNumber: ControlProperty<String> {
 return base.rx.controlProperty(
 editingEvents: UIControlEvents.valueChanged,
 getter: { $0.nationalNumber },
 setter: { _,_ in }
 )
 }
 
 var isValidNumber: ControlProperty<Bool> {
 return base.rx.controlProperty(
 editingEvents: UIControlEvents.valueChanged,
 getter: { $0.isValidNumber },
 setter: { _,_ in}
 )
 }
 
 var region: ControlProperty<String> {
 return base.rx.controlProperty(
 editingEvents: UIControlEvents.valueChanged,
 getter: { $0.region },
 setter: { _,_ in}
 )
 }
 }*/

//class TextField: PhoneNumberTextField { }
