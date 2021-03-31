//
//  ChatBotInitResponse.swift
//  MyBeeline
//
//  Created by admin on 10/22/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import Foundation

public struct ChatBotInitResponse: Codable {
    
    public let success: Bool?
    public let action: String
    public let responses: [ChatBotResponse]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case action
        case responses
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        action = try container.decode(String.self, forKey: .action)
        responses = try container.decodeIfPresent([ChatBotResponse].self, forKey: .responses)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(success, forKey: .success)
        try container.encode(action, forKey: .action)
        try container.encodeIfPresent(responses, forKey: .responses)
    }
}
