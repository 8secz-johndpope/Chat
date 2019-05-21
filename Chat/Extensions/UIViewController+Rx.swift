//
//  UIViewController+Rx.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/21/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    var keyboardHeight: Observable<CGFloat> {
        return Observable.from([
            NotificationCenter.default.rx
                .notification(UIResponder.keyboardWillShowNotification)
                .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 },
            NotificationCenter.default.rx
                .notification(UIResponder.keyboardWillHideNotification)
                .map { _ -> CGFloat in 0 }
            ])
            .merge()
    }
}
