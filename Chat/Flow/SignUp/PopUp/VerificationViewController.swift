//
//  PopUpViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/7/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxSwift

class VerificationViewController: UIViewController {

    //MARK: UI
    private var popUpView: PopUpView!
    private var activityIndicator: NVActivityIndicatorView!
    
    //MARK: Properties
    private var viewModel: VerificatiobViewModel!
    private let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.activityIndicator = NVActivityIndicatorView(frame: frame,
                                                        type: .ballRotateChase,
                                                        color: SystemColor.blue.uiColor)
        activityIndicator.startAnimating()
        
        popUpView = PopUpView(title: "Email Verification",
                              description: "Check Your Email",
                              view: activityIndicator,
                              buttonText: "Cancel")
        
        view.addSubview(popUpView)
        popUpView.center = view.center
        popUpView.delegate = self
        
        configureViewModel()
    }
    
    //MARK: Methods
    private func configureViewModel() {
        viewModel.output.changeViewObservable
            .subscribe(onNext: { [weak self] _ in
                self?.activityIndicator.stopAnimating()
                self?.changePopUpViewContent()
            })
            .disposed(by: disposeBag)
    }

    private func changePopUpViewContent() {
        let imageView = UIImageView(image: R.image.success())
        imageView.contentMode = .scaleAspectFit
        popUpView.setButtonTitle("OK")
        popUpView.setContent(view: imageView)
    }
}

extension VerificationViewController {
    
    static func create(with viewModel: VerificatiobViewModel) -> VerificationViewController {
        let viewController = R.storyboard.auth.verificationViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}

extension VerificationViewController: PopUpViewDelegate {
    
    func buttonPressed() {
        viewModel.input.buttonDidTap.onNext(())
        viewModel.input.buttonDidTap.onCompleted()
    }
}
