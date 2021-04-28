//
//  Message.swift
//  MyBeeline
//
//  Created by admin on 9/16/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import Foundation
import MessageKit

public struct Message: MessageType {
    
    public var sender: SenderType
    public var senderUser: SenderUser
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
    public var status: ChatMessageStatus?
    
    public init(senderUser: SenderUser,
         messageId: String,
         sentDate: Date,
         kind: MessageKind,
         status: ChatMessageStatus?
    ) {
        self.senderUser = senderUser
        sender = senderUser
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
        self.status = status
    }
    
    public init(chatMessage: ChatBotMessage) {
        sender = chatMessage.sender
        senderUser = chatMessage.sender
        messageId = chatMessage.messageId
        sentDate = chatMessage.sentDate
        status = chatMessage.status
        switch chatMessage.kind {
        case .bot(let viewModel):
            self.kind = .custom(viewModel)
        case .user(let text):
            self.kind = .text(text)
        case .image(let data):
            let image = ImageMediaItem(data: data)
            self.kind = .photo(image)
        default:
            kind = .text("")
        }
    }
}

extension Message: Equatable {
    
    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

enum ChatMessageKind {
    case bot(viewModel: ChatBotActionCellViewModel)
    case user(text: String)
    case image(data: Data)
}

extension ChatMessageKind: Codable {
    
    enum Keys: CodingKey {
        case rawValue
        case associatedValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            let viewModel = try container.decode(ChatBotActionCellViewModel.self, forKey: .associatedValue)
            self = .bot(viewModel: viewModel)
        case 1:
            let text = try container.decode(String.self, forKey: .associatedValue)
            self = .user(text: text)
        case 2:
            let data = try container.decode(Data.self, forKey: .associatedValue)
            self = .image(data: data)
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        switch self {
        case .bot(let viewModel):
            try container.encode(0, forKey: .rawValue)
            try container.encode(viewModel, forKey: .associatedValue)
        case .user(let text):
            try container.encode(1, forKey: .rawValue)
            try container.encode(text, forKey: .associatedValue)
        case .image(let data):
            try container.encode(2, forKey: .rawValue)
            try container.encode(data, forKey: .associatedValue)
        }
    }
}

public struct ChatBotMessage {
    
    public enum CodingKeys: String, CodingKey {
        case sender
        case messageId
        case sentDate
        case kind
        case status
    }
    
    var sender: SenderUser
    var messageId: String
    var sentDate: Date
    var kind: ChatMessageKind?
    var status: ChatMessageStatus?
    
    public init(message: Message) {
        sender = message.senderUser
        messageId = message.messageId
        sentDate = message.sentDate
        status = message.status
        switch message.kind {
        case .text(let text):
            kind = .user(text: text)
        case .custom(let viewModel):
            guard let viewModel = viewModel as? ChatBotActionCellViewModel else {
                kind = nil
                return
            }
            
            kind = .bot(viewModel: viewModel)
        case .photo(let image):
            guard let image = image as? ImageMediaItem else {
                kind = nil
                return
            }
            kind = .image(data: image.data)
        default:
            kind = nil
        }
    }
}

extension ChatBotMessage: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try sender = container.decode(SenderUser.self, forKey: .sender)
        try messageId = container.decode(String.self, forKey: .messageId)
        try sentDate = container.decode(Date.self, forKey: .sentDate)
        try kind = container.decode(ChatMessageKind.self, forKey: .kind)
        try status = container.decode(ChatMessageStatus.self, forKey: .status)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sender, forKey: .sender)
        try container.encode(messageId, forKey: .messageId)
        try container.encode(sentDate, forKey: .sentDate)
        try container.encode(kind, forKey: .kind)
        try container.encode(status, forKey: .status)
    }
}
