//
//  PhoneVerificationViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/2/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class PhoneVerificationViewController: UIViewController {

    private var viewModel: PhoneVerificationViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
    }
    
    private func configureViewModel() {
        
    }

}

extension PhoneVerificationViewController {
    
    static func create(with viewModel: PhoneVerificationViewModel) -> PhoneVerificationViewController {
        let viewController = R.storyboard.auth.phoneVerificationViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
