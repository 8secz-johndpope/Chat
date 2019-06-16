//
//  UIViewController+Toast.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/21/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func showErrorToast(error: Error) {
        let errorImageIview = UIImageView(image: R.image.error())
        errorImageIview.contentMode = .scaleToFill
        
        self.view.showToast(text: error.localizedDescription, view: errorImageIview, duration: 3.0)
    }
    
    func showUpdatingToast() {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),
                                                        type: .circleStrokeSpin)
        self.view.showToast(text: "loading...", view: activityIndicator)
    }
    
    func hideToast() {
        self.view.stopToast()
    }
}
