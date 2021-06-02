//
//  ChatBotResponse.swift
//  MyBeeline KZ
//
//  Created by admin on 10/22/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import Foundation

public struct ChatBotResponse: Codable {
    public let id = UUID().uuidString
    public let response: String
    public let operatorConnected: Bool
    public let sendDate: Date
    public let buttons: [ChatActionButtonModel]
    private let createdAt: Int
    public var assessParam: AssessmentParameter?
    public var hidden: String?
    
    enum CodingKeys: String, CodingKey {
        case response
        case operatorConnected
        case createdDate = "createdAt"
        case buttons
        case assessParam
        case hidden
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        response = try container.decode(String.self, forKey: .response)
        operatorConnected = try container.decode(Bool.self, forKey: .operatorConnected)
        createdAt = try container.decode(Int.self, forKey: .createdDate)
        sendDate = Date(timeIntervalSince1970: TimeInterval(createdAt/1000))
        buttons = try container.decode([ChatActionButtonModel].self, forKey: .buttons)
        if container.contains(.assessParam) {
            assessParam = try container.decode(AssessmentParameter.self, forKey: .assessParam)
        } else {
            assessParam = .empty
        }
        if container.contains(.hidden) {
            hidden = try container.decode(String.self, forKey: .hidden)
        } else {
            hidden = "false"
        }
//        hidden = try container.decode(String.self, forKey: .hidden)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(response, forKey: .response)
        try container.encode(operatorConnected, forKey: .operatorConnected)
        try container.encode(createdAt, forKey: .createdDate)
        try container.encode(buttons, forKey: .buttons)
        try container.encode(assessParam?.rawValue, forKey: .assessParam)
    }
}
