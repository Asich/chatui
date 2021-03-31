//
//  ChatActionButtonModel.swift
//  MyBeeline KZ
//
//  Created by admin on 10/22/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import Foundation

public struct ChatActionButtonModel: Codable {
    
    let action: String?
    let name: String
    let schemaId: String
    let stepId: Int
    let buttonId: String
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case action
        case name
        case schemaId
        case stepId
        case buttonId
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        action = try container.decodeIfPresent(String.self, forKey: .action)
        schemaId = try container.decode(String.self, forKey: .schemaId)
        stepId = try container.decode(Int.self, forKey: .stepId)
        buttonId = try container.decode(String.self, forKey: .buttonId)
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(action, forKey: .action)
        try container.encode(schemaId, forKey: .schemaId)
        try container.encode(stepId, forKey: .stepId)
        try container.encode(buttonId, forKey: .buttonId)
        try container.encode(url, forKey: .url)
    }
}
