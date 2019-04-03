//
//  ResetPasswordViewModel.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/19/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseAuth

class ResetPasswordViewModel: ViewModelProtocol {

    //MARK: Input-Output
    struct Input {
        let email: AnyObserver<String>
        let resetDidTap: AnyObserver<Void>
    }

    struct Output {
        let resetObservable: Observable<Void>
        let resultSubject: Observable<Void>
        let errorObservable: Observable<Error>
    }

    let input: Input
    let output: Output

    //MARK: Subjects
    private let emailSubject = PublishSubject<String>()
    private let resetSubject = PublishSubject<Void>()
    private let resultSubject = PublishSubject<Void>()
    private let errorSubject = PublishSubject<Error>()

    private let disposeBag = DisposeBag()

    //MARK: Init
    init() {
        self.input = Input(email: emailSubject.asObserver(),
                           resetDidTap: resetSubject.asObserver())

        self.output = Output(resetObservable: resetSubject.asObservable(),
                             resultSubject: resultSubject.asObservable(),
                             errorObservable: errorSubject.asObservable())

        resetSubject.withLatestFrom(emailSubject).flatMapLatest { email in
                return AuthenticationService.sendPasswordReset(with: email).materialize()
            }.subscribe(onNext: { [weak self] (event) in
                switch event {
                case .error(let error):
                    self?.errorSubject.onError(error)
                case .completed:
                    self?.resultSubject.onNext(())
                    self?.resultSubject.onCompleted()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

}

//class ResetPasswordViewModel: ViewModelProtocol {
//
//    //MARK: Input-Output
//    struct Input {
//        let email: Driver<String>
//        let resetDidTap: Driver<Void>
//    }
//
//    struct Output {
//        let resetObservable: Driver<Void>
//        let resultSubject: Driver<Void>
//        let errorObservable: Driver<Error>
//    }
//
//    //MARK: Subjects
//    let emailSubject = PublishSubject<String>()
//    let resetSubject = PublishSubject<Void>()
//    let resultSubject = PublishSubject<Void>()
//    let errorSubject = PublishSubject<Error>()
//
//    private let disposeBag = DisposeBag()
//
//    //MARK: Init
//    func transform(input: Input) -> Output {
//        let resetTriggered = input.resetDidTap
//
//        resetSubject.withLatestFrom(emailSubject).flatMapLatest { email in
//            return AuthenticationService.sendPasswordReset(with: email).materialize()
//            }.subscribe(onNext: { [weak self] (event) in
//                switch event {
//                case .error(let error):
//                    self?.errorSubject.onError(error)
//                case .completed:
//                    self?.resultSubject.onNext(())
//                    self?.resultSubject.onCompleted()
//                default:
//                    break
//                }
//            })
//            .disposed(by: disposeBag)
//
//        return Output(resetObservable: resetTriggered,
//                      resultSubject: <#T##Driver<Void>#>,
//                      errorObservable: <#T##Driver<Error>#>)
//    }
//
//}
