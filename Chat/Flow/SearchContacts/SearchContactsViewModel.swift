//
//  SearchContactsViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/16/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import Foundation

class SearchContactsViewModel: ViewModelProtocol {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    let input: Input
    let output: Output
    
    init() {
        self.input = Input()
        self.output = Output()
    }
}
