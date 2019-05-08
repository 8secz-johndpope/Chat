//
//  CountriesSearchViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/3/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa
import PhoneNumberKit

class CountriesViewModel: ViewModelProtocol {
    
    struct Input {
        let backButtonDidTap: AnyObserver<Void>
        let searchBarText = BehaviorSubject<String>(value: "")
        let selection: AnyObserver<Country>
    }
    
    struct Output {
        let backButtonObservable: Driver<Void>
        let selectionObservable: Observable<Country>
        let sections: BehaviorRelay<[Section]>
    }
    
    let input: Input
    let output: Output
    
    let countries = BehaviorRelay<[Country]>(value: allCountries)
    private let sectionsSubject = PublishSubject<[Section]>()
    private let selectionSubject = PublishSubject<Country>()
    private let backButtonSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.input = Input(backButtonDidTap: backButtonSubject.asObserver(),
                           selection: selectionSubject.asObserver())
        self.output = Output(backButtonObservable: backButtonSubject.asDriver(onErrorJustReturn: ()),
                             selectionObservable: selectionSubject.asObservable(),
                             sections: BehaviorRelay<[Section]>(value: []))
        
        input.searchBarText.asObservable()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (text) in
                self?.reloadSections(with: text)
            })
            .disposed(by: disposeBag)  
    }
    
    func reloadSections(with text: String) {
        var countries = allCountries
        
        if !text.isEmpty {
            countries = countries.filter { $0.name.localizedCaseInsensitiveContains(text) }
        }
        
        let letters = Array(Set(countries.compactMap { $0.name.first }))
        var sections = [String: [Country]]()
        
        for letter in letters.map({ String($0) }) {
            sections[letter] = countries.filter({ $0.name.hasPrefix(letter) }).sorted(by: { (c1, c2) -> Bool in
                return c1.name < c2.name
            })
        }
        
        let items = sections.map { (key, value) -> Section in
                return Section(header: key, countries: value)
            }
            .sorted { (s1, s2) -> Bool in
                return s1.header < s2.header
            }
        
        self.output.sections.accept(items)
    }
}
