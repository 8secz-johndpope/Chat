//
//  ChatViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/19/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit
import MessageInputBar
import MessageKit
import FirebaseAuth
import Kingfisher
import RxSwift

extension UIColor {
    static let primary = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
}

class ChatViewController: MessagesViewController {

    var chatTitleView: ChatTitleView!
    
    var viewModel: ChatViewModel!
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMessagesUI()
        configureNavigationBarUI()
        configureViewModel()
    }
    
    private func configureMessagesUI() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .primary
        messageInputBar.sendButton.tintColor = .primary
    }
    
    private func configureNavigationBarUI() {
        guard let navigationBarSize = navigationController?.navigationBar.frame.size else { return }
        
        let frame = CGRect(x: 0, y: 0, width: navigationBarSize.width * 0.5, height: navigationBarSize.height)
        let title = viewModel.companion.username
        let imageUrl = URL(string: viewModel.companion.imageUrl)
        let imageView = UIImageView()
        imageView.kf.setImage(with: imageUrl)
        
        chatTitleView = ChatTitleView(frame: frame,
                                      profileImageView: imageView,
                                      profileTitle: title,
                                      status: "offline")
        
        navigationItem.titleView = chatTitleView
        navigationController?.navigationBar.topItem?.title = ""        
    }
    
    private func configureViewModel() {        
        viewModel.output.newMessageObservable.subscribe(onNext: { [weak self] message in
            self?.insertMessage(message)
        }).disposed(by: disposeBag)
    }

    private func insertMessage(_ message: Message) {
        let messagesCount = viewModel.getMessagesCount()

        viewModel.sortMessages()
        messagesCollectionView.reloadData()
        
//        messagesCollectionView.performBatchUpdates({
//            messagesCollectionView.insertSections([messagesCount - 1])
//            if messagesCount >= 2 {
//                messagesCollectionView.reloadSections([messagesCount - 2])
//            }
//        }, completion: { [weak self] _ in
//            if self?.isLastSectionVisible() == true {
//                self?.messagesCollectionView.scrollToBottom(animated: true)
//            }
//        })
    }
    
    private func isLastSectionVisible() -> Bool {
        guard viewModel.getMessagesCount() != 0 else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: viewModel.getMessagesCount() - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }

}

extension ChatViewController {
    
    static func create(with viewModel: ChatViewModel) -> ChatViewController {
        let viewController = R.storyboard.main.chatViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
}

extension ChatViewController: MessagesDataSource  {
    
    func currentSender() -> Sender {
        return viewModel.sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.getMessage(at: indexPath.section)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return viewModel.getMessagesCount()
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                                      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                                   NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType,
                         at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? .primary : .red
            //.incomingMessage
    }
    
    func shouldDisplayHeader(for message: MessageType,
                             at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        
        return false
    }
    
    func messageStyle(for message: MessageType,
                      at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(corner, .curved)
    }
    
}

// MARK: - MessageInputBarDelegate
extension ChatViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let str = component as? String {
                let message = Message(text: str,
                                      sender: currentSender(),
                                      messageId: UUID().uuidString,
                                      date: Date())
                
                viewModel.sendMessage(message)
                insertMessage(message)
            }
//            else if let img = component as? UIImage {
//                let message = Message(image: img,
//                                      sender: currentSender(),
//                                      messageId: UUID().uuidString,
//                                      date: Date())
//                insertMessage(message)
//            }
        }
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
}
