//
//  ChatBotActionCollectionViewCell.swift
//  MyBeeline
//
//  Created by admin on 9/17/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import UIKit
import MessageKit
import SnapKit

class ChatBotActionCollectionViewCell: UICollectionViewCell {
    
    private var container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private var userTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .unavailableGray
        return label
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .black
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private var avatarImageView: UIImageView = {
        return UIImageView(image: UIImage(named: "chat_bot_beeline_avatar"))
    }()
    
    private var viewModel: ChatBotActionCellViewModel?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        self.layer.cornerRadius = 8
        backgroundColor = .clear
        
        addSubview(container)
        container.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        container.addSubview(contentContainer)
        contentContainer.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo((UIScreen.main.bounds.width * 4) / 5)
        }
        
        container.addSubview(spacer)
        spacer.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(contentContainer.snp.trailing)
        }
        
        contentContainer.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.height.width.equalTo(26)
            make.leading.top.equalToSuperview().offset(16)
        }
        
        contentContainer.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(15)
        }
        
        contentContainer.addSubview(userTypeLabel)
        userTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel.snp.leading)
            make.trailing.equalTo(userNameLabel.snp.trailing)
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.height.equalTo(15)
        }
        
        contentContainer.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(userTypeLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }

    open func configure(with message: MessageType,
                        at indexPath: IndexPath,
                        and messagesCollectionView: MessagesCollectionView, cellConfiguration: ChatViewCellConfigurationProtocol?) {
        switch message.kind {
        case .custom(let viewModel):
            guard let viewModel = viewModel as? ChatBotActionCellViewModel else { return }
            self.viewModel = viewModel
            contentContainer.backgroundColor = cellConfiguration?.backgroundColor
            userNameLabel.textColor = cellConfiguration?.textColor
//            messageLabel.text = viewModel.text
            configureMessageLabelColor(message: viewModel.message, configuration: cellConfiguration)
            if message.sender.senderId == SenderUser.SenderUserType.bot.rawValue {
                avatarImageView.image = cellConfiguration?.botImage
                userNameLabel.text = cellConfiguration?.botMessageTitleText
                userTypeLabel.text = cellConfiguration?.botMessageSubtitleText
            } else {
                avatarImageView.image = cellConfiguration?.operatorImage
                userNameLabel.text = cellConfiguration?.operatorMessageTitleText
                userTypeLabel.text = cellConfiguration?.operatorMessageSubtitleText
            }
        default:
            return
        }
    }

    func configureMessageLabelColor(message: NSMutableAttributedString?, configuration: ChatViewCellConfigurationProtocol?) {
        message?.addAttribute(.foregroundColor, value: configuration?.textColor ?? .black, range: NSRange(location: 0, length: message?.length ?? 0))
        messageLabel.attributedText = message
    }
}

@objc protocol ChatBotActionDelegate: class {
    
    func actionDidPress(sender: UIButton)
}
