//
//  ChatViewController+MessageKit.swift
//  DMVNO
//
//  Created by User on 19.03.2021.
//  Copyright © 2021 VEON. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import InputBarAccessoryView

// MARK: MessagesCollectionView configuration
extension ChatViewController {
    func configureMessagesCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToBottomOnKeyboardBeginsEditing = false
    }

    func hideOutgoingMessageAvatarView() {
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
    }

}
// MARK: Messages data source
extension ChatViewController: MessagesDataSource {
    public func currentSender() -> SenderType {
        guard let presenter = presenter else { return SenderUser(senderUserType: .currentSender) }
        return presenter.getCurrentSender()
    }
    
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let messages: [Message] = []
        guard let presenter = presenter else { return messages[indexPath.section] }
        return presenter.getMessageForItem(at: indexPath)
    }
    
    public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        guard let numberOfSections = presenter?.getNumberOfSections() else { return 0 }
        if numberOfSections > 0 {
            hideEmptyView()
        }
        return numberOfSections
    }

    public func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            guard let presenter = presenter else { return NSAttributedString() }
            let status = presenter.getMessageStatusForItem(at: indexPath)
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1), .foregroundColor: UIColor.darkGray]
        switch status {
        case .sending:
            return NSAttributedString(string: configuration?.messageStatusText?.sending ?? "", attributes: attributes)
        case .sent:
            return NSAttributedString(string: configuration?.messageStatusText?.sent ?? "", attributes: attributes)
        case .failure:
            return NSAttributedString(string: configuration?.messageStatusText?.failure ?? "", attributes: attributes)
        }
    }

    public func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}

extension ChatViewController: MessageCellDelegate {}

extension ChatViewController: MessagesLayoutDelegate {
    public func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        switch message.kind {
        case .text:
            return configuration?.cellConfiguration?.textColor ?? .black
        default:
            return .black
        }
    }
    
    public func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        switch message.kind {
        case .text:
            return .userMessageBG
        default:
            return .veryLightBlue
        }
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    public func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let image):
            guard let image = image as? ImageMediaItem else { return }
            imageView.image = UIImage(data: image.data)
        default:
            return
        }
    }
    public func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        guard presenter != nil else { return .bubbleTail(.bottomLeft, .curved) }
        return .bubbleTail(isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft, .curved)
    }

    public func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        guard let presenter = presenter else { return .zero }
        let size = CGSize(width: messagesCollectionView.frame.width, height: 24)
        if section == 0 {
            return size
        }
        
        let currentIndexPath = IndexPath(row: 0, section: section)
        let lastIndexPath = IndexPath(row: 0, section: section - 1)
        let lastMessage = presenter.getMessageForItem(at: lastIndexPath)
        let currentMessage = presenter.getMessageForItem(at: currentIndexPath)
        
        if currentMessage.sentDate.isInSameDayAndTimeOf(date: lastMessage.sentDate) {
            return .zero
        }
        
        return size
    }

    // MARK: Header
    public func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        guard let presenter = presenter else { return MessageDateReusableView() }
        let message = presenter.getMessageForItem(at: indexPath)
        let header = messagesCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MessageDateReusableViewModel", for: indexPath) as! MessageDateReusableView
        let viewModel = MessageDateReusableViewModel(date: message.sentDate, localizedText: configuration?.dateLabelText)
        header.configure(viewModel: viewModel)
        return header
    }

    // MARK: Footer
    public func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        guard let presenter = presenter else { return .zero }
        let indexPath = IndexPath(row: 0, section: section)
        let message = presenter.getMessageForItem(at: indexPath)
        switch message.kind {
        case .custom(let viewModel):
            guard let viewModel = viewModel as? ChatBotActionCellViewModel else { return .zero }
            let height = viewModel.buttonsViewHeight
            return CGSize(width: messagesCollectionView.bounds.width, height: height)
        default:
            return .zero
        }
    }

    public func messageFooterView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        guard let presenter = presenter else { return MessageButtonFooterView() }
        let message = presenter.getMessageForItem(at: indexPath)
        let footer = messagesCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MessageButtonFooterView.classIdentifierName, for: indexPath) as! MessageButtonFooterView
        switch message.kind {
        case .custom(let viewModel):
            guard let viewModel = viewModel as? ChatBotActionCellViewModel else { return footer }
            footer.configure(viewModels: viewModel.buttonViewModels)
            return footer
        default:
            return footer
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url]
    }
}

// MARK: Input bar configuration
extension ChatViewController: InputBarAccessoryViewDelegate {
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = false
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 8)
        messageInputBar.inputTextView.placeholder = configuration?.inputBarPlaceholderText

        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = configuration?.sendButtonImage?.inactive
        messageInputBar.sendButton
            .onEnabled { [weak self] _ in
                self?.messageInputBar.sendButton.setImage(self?.configuration?.sendButtonImage?.active, for: .normal)
            }.onDisabled { [weak self] _ in
                self?.messageInputBar.sendButton.setImage(self?.configuration?.sendButtonImage?.inactive, for: .normal)
            }
        messageInputBar.sendButton.title = nil
        messageInputBar.inputTextView.backgroundColor = configuration?.inputBarColor?.textView
        messageInputBar.backgroundView.backgroundColor = configuration?.inputBarColor?.background
        messageInputBar.inputTextView.placeholderTextColor = configuration?.inputBarColor?.placeholder
        setAttachButton()
    }

    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        presenter?.userHasSent(message: text)
        inputBar.inputTextView.text = ""
    }
}
