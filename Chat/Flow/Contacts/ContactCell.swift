//
//  ContactCell.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/12/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContactCell: UITableViewCell {
    
    lazy var contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var contactTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    static var identifier: String {
        return String(describing: self)
    }

    var viewModel: ContactCellViewModel!
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(containerView)
        containerView.addSubview(contactImageView)
        containerView.addSubview(contactTitleLabel)
        
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2.0).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2.0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.0).isActive = true
        
        contactImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0).isActive = true
        contactImageView.trailingAnchor.constraint(equalTo: contactTitleLabel.leadingAnchor, constant: -12.0).isActive = true
        contactImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4.0).isActive = true
        contactImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4.0).isActive = true
        contactImageView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        contactImageView.widthAnchor.constraint(equalTo: contactImageView.heightAnchor).isActive = true

        contactTitleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        contactTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layoutIfNeeded()
        contactImageView.layer.cornerRadius = contactImageView.frame.width / 2
    }
    
    func bind(to viewModel: ContactCellViewModel) {
        self.viewModel = viewModel
        
        self.viewModel.contactImageUrl
            .drive(contactImageView.rx.imageURL)
            .disposed(by: disposeBag)
        
        self.viewModel.contactTitle
            .drive(contactTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
