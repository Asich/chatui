//
//  File.swift
//  
//
//  Created by User on 14.03.2021.
//

import Foundation

public struct MessageDeliveryStatus: Codable {
    public var action: String?
    public var requestId: String?
    public var success: Bool?
}
