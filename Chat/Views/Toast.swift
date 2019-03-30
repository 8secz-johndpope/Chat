//
//  File.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/27/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Toast: UIView {
    
    private var activityView: UIView
    private var textLabel: UILabel
    
    private var indent: CGFloat = 8.0
    
    init(text: String? = nil,
         view: UIView,
         backgroundColor: UIColor = .lightGray,
         textColor: UIColor = .black) {
        
        self.activityView = view
        
        self.textLabel = UILabel()
        
        super.init(frame: CGRect(x: 0, y: 0, width: 90, height: 110))
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.textLabel.text = text
        self.textLabel.textAlignment = .center
        self.textLabel.numberOfLines = 0
        self.textLabel.textColor = textColor
        self.textLabel.adjustsFontSizeToFitWidth = true
        self.backgroundColor = backgroundColor
        self.alpha = 0.5
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityView)
        addSubview(textLabel)
        
        configureConstraints()
        //activityView.sizeToFit()
        //textLabel.sizeToFit()
    }
    
    private func configureConstraints() {
        frame = CGRect(x: 0,
                       y: 0,
                       width: frame.width,
                       height: activityView.frame.height + textLabel.intrinsicContentSize.height + 3 * indent)
        
        activityView.topAnchor.constraint(equalTo: topAnchor, constant: indent).isActive = true
        activityView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: indent).isActive = true
        activityView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: -indent).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: activityView.frame.height).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: activityView.bottomAnchor, constant: indent).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -indent).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: indent).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -indent).isActive = true
        textLabel.preferredMaxLayoutWidth = frame.width - 2 * indent
    }
    
    func show(on view: UIView, position: CGPoint, duration: Int?) {
        center = position
        view.addSubview(self)
        transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
        if let duration = duration {
            Timer.scheduledTimer(timeInterval: TimeInterval(duration), target: self, selector: #selector(stop), userInfo: nil, repeats: false)
        }
    }
    
    @objc func stop() {
        removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    
    private struct ToastAssociatedKeys {
        static var toast = "toast"
    }
    
    private var toast: Toast? {
        get {
            return objc_getAssociatedObject(self, &ToastAssociatedKeys.toast) as? Toast
        }
        set(newValue) {
            objc_setAssociatedObject(self,
                                     &ToastAssociatedKeys.toast,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showToast(text: String, view: UIView, duration: Int? = nil) {
        if self.toast != nil { self.toast?.removeFromSuperview() }
        self.toast = Toast(text: text, view: view)
        guard let toast = toast else { return }
        
        isUserInteractionEnabled = false
        addSubview(toast)
        toast.center = center
        toast.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
            toast.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
        if let duration = duration {
            Timer.scheduledTimer(timeInterval: TimeInterval(duration),
                                 target: self,
                                 selector: #selector(stopToast),
                                 userInfo: nil,
                                 repeats: false)
        }
    }
    
    @objc func stopToast() {
        self.isUserInteractionEnabled = true
        self.toast?.removeFromSuperview()
    }
}
