//
//  Kingfisher+rx.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/30/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

extension Reactive where Base: UIImageView {
    
    public var imageURL: Binder<URL?> {
        return self.imageURL(withPlaceholder: nil)
    }
    
    public func imageURL(withPlaceholder placeholderImage: UIImage?, options: KingfisherOptionsInfo? = []) -> Binder<URL?> {
        return Binder(self.base, binding: { (imageView, url) in
            imageView.kf.setImage(with: url,
                                  placeholder: placeholderImage,
                                  options: options,
                                  progressBlock: nil,
                                  completionHandler: { (result) in })
        })
    }
}
