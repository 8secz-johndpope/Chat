//
//  CountryCellViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/4/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class CountryCellViewModel: ViewModelProtocol {
    
    struct Input {
        
    }
    
    struct Output {
        let countryFlag: Driver<UIImage?>
        let countryTitle: Driver<String>
        let countryCode: Driver<String>
    }
    
    let input: Input
    let output: Output
    private let country: Country
    
    init(country: Country) {
        self.country = country
        self.input = Input()
        
        let path = Bundle.main.path(forResource: country.code, ofType: "png", inDirectory: "countries")
        let image = UIImage(contentsOfFile: path ?? "")
        self.output = Output(countryFlag: Driver.just(image),
                             countryTitle: Driver.just(country.name),
                             countryCode: Driver.just("+\(String(country.phoneCode))"))
        
    }
}
