//
//  SenderUser.swift
//  MyBeeline
//
//  Created by admin on 9/17/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import Foundation
import MessageKit

public struct SenderUser: SenderType, Equatable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case senderId
        case displayName
        case type
    }
    
    public enum SenderUserType: String {
        case bot
        case currentSender
        case answeringPerson
        
        var displayName: String {
            //TODO: Localized
            switch self {
            case .bot:
                return "chat_bot.message.title".localized
            case .answeringPerson:
                return "chat_bot.message.asistent.title".localized
            case .currentSender:
                return "Я"
            }
        }
        
        var type: String {
            switch self {
            case .bot:
                return "chat_bot.message.type".localized
            case .answeringPerson:
                return "chat_bot.message.asistent.type".localized
            case .currentSender:
                return "Я"
            }
        }
    }
    
    public var senderId: String
    public var displayName: String
    public var type: String
    
    public init(senderType: SenderType, type: String) {
        self.senderId = senderType.senderId
        self.displayName = senderType.displayName
        self.type = type
    }
    
    public init(senderUserType: SenderUserType) {
        senderId = senderUserType.rawValue
        displayName = senderUserType.displayName
        type = senderUserType.type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        senderId = try container.decode(String.self, forKey: .senderId)
        displayName = try container.decode(String.self, forKey: .displayName)
        type = try container.decode(String.self, forKey: .type)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(type, forKey: .type)
    }
    
    public static func == (lhs: SenderUser, rhs: SenderUser) -> Bool {
        return lhs.senderId == rhs.senderId
    }
}
