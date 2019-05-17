//
//  ProfileHeaderView.swift
//  Chat
//
//  Created by Vadim Koronchik on 5/15/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class ProfileHeaderView: UIView {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileTitleLabel: UILabel!
    
    private var viewModel = ProfileHeaderViewModel()
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViewModel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    func configureViewModel() {
        self.viewModel.profileImageUrl
            .drive(profileImageView.rx.imageURL)
            .disposed(by: disposeBag)
        
        self.viewModel.profileTitle
            .drive(profileTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
