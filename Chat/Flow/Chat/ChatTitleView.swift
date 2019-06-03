//
//  ChatTitleView.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/21/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ChatTiteViewDelegate: class  {
    func profileImagePressed(_ view: ChatTitleView)
}

class ChatTitleView: UIView {
    
    var profileImageView: UIImageView!
    var profileTitleLabel: UILabel!
    var bottomTextLabel: UILabel!
    private var contentView: UIView!
    
    weak var delegate: ChatTiteViewDelegate?
    private var viewModel: ChatTitleViewModel!
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView = UIView()
        self.profileImageView = UIImageView(image: R.image.profile())
        self.profileTitleLabel = UILabel()
        self.bottomTextLabel = UILabel()
        
        commonInit()
    }
    
    init(frame: CGRect, profileImageView: UIImageView?, profileTitle: String?, status: String?) {
        super.init(frame: frame)
    
        self.contentView = UIView()
        self.profileImageView = profileImageView
        self.profileTitleLabel = UILabel()
        self.bottomTextLabel = UILabel()
        
        self.profileTitleLabel.text = profileTitle
        self.bottomTextLabel.text = status

        commonInit()
    }
    
    private func commonInit() {
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = 20
        self.profileImageView.layer.borderWidth = 1.0
        
        self.profileTitleLabel.adjustsFontSizeToFitWidth = true
        self.profileTitleLabel.textAlignment = .center
        self.profileTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.bottomTextLabel.adjustsFontSizeToFitWidth = true
        self.bottomTextLabel.textAlignment = .center
        self.bottomTextLabel.font = UIFont.systemFont(ofSize: 12)
        self.bottomTextLabel.textColor = .gray
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bottomTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.profileTitleLabel)
        self.contentView.addSubview(self.bottomTextLabel)
        
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.0).isActive = true
        profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        profileTitleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        profileTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        profileTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        profileTitleLabel.bottomAnchor.constraint(equalTo: bottomTextLabel.topAnchor).isActive = true
        profileTitleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        
        bottomTextLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 4).isActive = true
        bottomTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bottomTextLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4).isActive = true
    }
    
    func bind(to viewModel: ChatTitleViewModel) {
        self.viewModel = viewModel
        
        self.viewModel.output
            .imageUrl
            .drive(profileImageView.rx.imageURL)
            .disposed(by: disposeBag)
        
        self.viewModel.output
            .username
            .drive(profileTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.output
            .status
            .drive(bottomTextLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
