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
    
    private var viewModel: PhoneInputViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
    }
    
    private func configureViewModel() {
        
    }
}

extension PhoneInputViewController {
    
    static func create(with viewModel: PhoneInputViewModel) -> PhoneInputViewController {
        let viewController = R.storyboard.auth.phoneInputViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
