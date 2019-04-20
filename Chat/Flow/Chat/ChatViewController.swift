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

extension UIColor {
    static let primaryColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
}

class ChatViewController: MessagesViewController {

    var viewModel: ChatViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureViewModel()
    }
    
    private func configureUI() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.sendButton.tintColor = .primaryColor
        
        
    }
    
    private func configureViewModel() {
        
    }

    func insertMessage(_ message: Message) {
        viewModel.sendMessage(message)
        
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([viewModel.messages.value.count - 1])
            if viewModel.messages.value.count >= 2 {
                messagesCollectionView.reloadSections([viewModel.messages.value.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        guard !viewModel.messages.value.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: viewModel.messages.value.count - 1)
        
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

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> Sender {
        return Sender(id: Auth.auth().currentUser?.uid ?? "",
                      displayName: Auth.auth().currentUser?.email ?? "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.messages.value[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return viewModel.messages.value.count
    }
    
}

// MARK: - MessageInputBarDelegate
extension ChatViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let str = component as? String {
                let message = Message(text: str, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = Message(image: img, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
}
