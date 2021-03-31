//
//  File.swift
//  
//
//  Created by User on 13.03.2021.
//

import Foundation

public enum ChatMessageStatus {
    case sending
    case sent
    case failure
}

extension ChatMessageStatus: Codable {
    
    enum CodingKeys: CodingKey {
        case rawValue
        case associatedValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .sending
        case 1:
            self = .sent
        case 2:
            self = .failure
        default:
            throw CodingError.unknownValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .sending:
            try container.encode(0, forKey: .rawValue)
        case .sent:
            try container.encode(1, forKey: .rawValue)
        case .failure:
            try container.encode(2, forKey: .rawValue)
        }
    }
}
