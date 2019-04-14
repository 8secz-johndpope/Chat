//
//  PopUpView.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/7/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit

protocol PopUpViewDelegate: class {
    func buttonPressed()
}

class PopUpView: UIView {
    
    private var titleLabel: UILabel
    private var descriptionLabel: UILabel
    private var contentView: UIView
    private var button: UIButton
    
    weak var delegate: PopUpViewDelegate?
    
    init(title: String, description: String, view: UIView, buttonText: String) {
        self.titleLabel = UILabel()
        self.descriptionLabel = UILabel()
        self.contentView = UIView()
        self.button = UIButton()
        
        super.init(frame: CGRect(x: 0, y: 0, width: 210, height: 155))
        
        clipsToBounds = true
        backgroundColor = .init(white: 0.8, alpha: 1.0)
        layer.cornerRadius = 20
        
        setContent(view: view)
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(contentView)
        addSubview(button)
        
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        contentView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()

        aPath.move(to: CGPoint(x: 0, y: button.frame.minY - 2))
        aPath.addLine(to: CGPoint(x: frame.width, y: button.frame.minY - 2))
        
        aPath.close()
        UIColor.gray.set()
        aPath.stroke()
        aPath.fill()
    }
    
    func setContent(view: UIView) {
        view.frame = contentView.bounds
        contentView.addSubview(view)
    }
    
    func setButtonTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
    @objc func buttonPressed() {
        delegate?.buttonPressed()
    }
}
