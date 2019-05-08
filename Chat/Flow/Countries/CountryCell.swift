//
//  CountryCell.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/4/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CountryCell: UITableViewCell {
    
    @IBOutlet var countryFlagImageView: UIImageView!
    @IBOutlet var countryTitleLabel: UILabel!
    @IBOutlet var countryPhoneCodeLabel: UILabel!
    
    private var viewModel: CountryCellViewModel!
    private let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        //countryFlagImageView.image = nil
    }
    
    func bind(to viewModel: CountryCellViewModel) {
        self.viewModel = viewModel
        
        self.viewModel.output
            .countryFlag
            .drive(countryFlagImageView.rx.image)
            .disposed(by: disposeBag)
        
        self.viewModel.output
            .countryTitle
            .drive(countryTitleLabel.rx.text)
            .disposed(by: disposeBag)
                
        self.viewModel.output
            .countryCode
            .drive(countryPhoneCodeLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
