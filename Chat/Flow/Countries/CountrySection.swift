//
//  CountrySection.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/5/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import Foundation
import RxDataSources

struct Section {
    
    var header: String
    var countries: [Country]
    
    init(header: String, countries: [Item]) {
        self.header = header
        self.countries = countries
    }
}

extension Section: SectionModelType {
    
    typealias Item = Country
    
    var items: [Country] {
        return countries
    }
    
    init(original: Section, items: [Country]) {
        self = original
        self.countries = items
    }
}
