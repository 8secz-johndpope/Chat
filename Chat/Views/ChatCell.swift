//
//  ChatCell.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/28/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import RxSwift

class ChatCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var messagesCountView: UIView!
    @IBOutlet var messagesCountLabel: UILabel!
    
    var viewModel: ChatCellViewModel!
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        messagesCountView.layer.cornerRadius = messagesCountView.frame.width / 2
    }
    
    func bind(to viewModel: ChatCellViewModel) {
        self.viewModel = viewModel
        
        self.viewModel.output
            .date
            .drive(timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.output
            .messageText
            .drive(messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.output
            .username
            .drive(usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.output
            .profileImageUrl
            .drive(profileImageView.rx.imageURL)
            .disposed(by: disposeBag)
        
        self.viewModel.output
            .newMessagesCount
            .drive(onNext: { [weak self] count in
                if count != 0 {
                    self?.messagesCountView.isHidden = false
                    self?.messagesCountLabel.text = String(count)
                } else {
                    self?.messagesCountView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}
