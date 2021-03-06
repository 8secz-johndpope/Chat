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
    @IBOutlet var verifyButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var countryFlagButton: UIButton!
    
    private var viewModel: PhoneInputViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        countryFlagButton.layer.cornerRadius = countryFlagButton.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    private func configureUI() {
        phoneNumberTextField.becomeFirstResponder()
        phoneNumberTextField.keyboardType = .numberPad
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
        
        viewModel.output.countryFlag
            .drive(countryFlagButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        (phoneNumberTextField.rx.text.orEmpty <-> viewModel.output.region).disposed(by: disposeBag)
        
        phoneNumberTextField.rx.controlEvent([.editingChanged])
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return Observable.empty() }
                return Observable.just(self.phoneNumberTextField.isValidNumber ) }
            .bind(to: viewModel.output.isValidNumber)
            .disposed(by: disposeBag)
        
        phoneNumberTextField.rx.controlEvent([.editingChanged])
            .flatMap { [weak self] _ -> Observable<String> in
                guard let self = self else { return Observable.empty() }
                return Observable.just(self.phoneNumberTextField.region ) }
            .subscribe(viewModel.input.region)
            .disposed(by: disposeBag)
        
        viewModel.output.isValidNumber
            .bind(to: verifyButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        phoneNumberTextField.rx.text.orEmpty
            .bind(to: viewModel.input.phoneNumber)
            .disposed(by: disposeBag)
        
        viewModel.output.isUpdating
            .subscribe(onNext: { [weak self] isUpdating in
                isUpdating ? self?.showUpdatingToast() : self?.hideToast()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isError
            .subscribe(onNext: { [weak self] error in
                self?.showErrorToast(error: error)
            })
            .disposed(by: disposeBag)
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

infix operator <-> : DefaultPrecedence

func <-> <T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property
        .subscribe(onNext: { n in
            relay.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}

//class TextField: PhoneNumberTextField { }
