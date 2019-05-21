//
//  File.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/27/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class Toast: UIView {
    
    private var activityView: UIView
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let prefferedWidth: CGFloat = 100.0
    private let minimumWidth: CGFloat = 70.0
    private let maxSize: CGSize = CGSize(width: 200.0, height: 300.0)
    private let indent: CGFloat = 12.0
    
    init(text: String? = nil,
         view: UIView,
         backgroundColor: UIColor = UIColor.silver,
         textColor: UIColor = .black) {
        
        self.activityView = view
        
        super.init(frame: CGRect(x: 0, y: 0, width: maxSize.width, height: maxSize.height))
        
        self.textLabel.text = text
        self.textLabel.textColor = textColor
        let textWidth = maxSize.width / textLabel.intrinsicContentSize.width < 0.5 ? maxSize.width : prefferedWidth
        let fontSize: CGFloat = textLabel.intrinsicContentSize.width > 400 ? 12.0 : 14.0
        self.textLabel.font = UIFont.systemFont(ofSize: fontSize)
        self.textLabel.preferredMaxLayoutWidth = textWidth < minimumWidth ? minimumWidth : textWidth
        
        self.activityView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: (textLabel.intrinsicContentSize.width + 20) / 2,
                                         height: (textLabel.intrinsicContentSize.width + 20) / 2)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = backgroundColor
        self.alpha = 0.9
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityView)
        addSubview(textLabel)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        let currentHeight = activityView.frame.height + textLabel.intrinsicContentSize.height + 3 * indent
        let newHeight = currentHeight
    
        frame = CGRect(x: 0, y: 0, width: newHeight, height: newHeight)
        
        activityView.topAnchor.constraint(equalTo: topAnchor, constant: indent).isActive = true
        activityView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityView.widthAnchor.constraint(equalToConstant: activityView.frame.width).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: activityView.frame.height).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: activityView.bottomAnchor, constant: indent).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -indent).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: indent).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -indent).isActive = true
        
        (activityView as? NVActivityIndicatorView)?.startAnimating()
    }
    
    func show(on view: UIView, position: CGPoint, duration: Double?) {
        center = position
        view.addSubview(self)
        transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
            self.transform = .identity
        }, completion: nil)
        
        if let duration = duration {
            Timer.scheduledTimer(timeInterval: TimeInterval(duration),
                                 target: self,
                                 selector: #selector(stop),
                                 userInfo: nil,
                                 repeats: false)
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
    
    func showToast(text: String, view: UIView, duration: Double? = nil) {
        if self.toast != nil { self.toast?.removeFromSuperview() }
        self.toast = Toast(text: text, view: view)
        guard let toast = toast else { return }
        
        isUserInteractionEnabled = false
        addSubview(toast)
        toast.center = center
        toast.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(UIView.handleToastTapped(_:)))
        toast.addGestureRecognizer(recognizer)
        toast.isUserInteractionEnabled = true
        toast.isExclusiveTouch = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
            toast.transform = .identity
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
    
    @objc private func handleToastTapped(_ recognizer: UITapGestureRecognizer) {
        stopToast()
    }
}
