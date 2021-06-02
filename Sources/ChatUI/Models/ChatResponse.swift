//
//  File.swift
//  
//
//  Created by User on 14.03.2021.
//

import Foundation

public struct ChatResponse: Codable {
    public var action: ChatActionType
    public var success: Bool?
}

public enum ChatActionType: String, Codable {
    case deliveryStatus = "deliveryStatus"
    case botResponse = "botResponse"
    case closeOperatorConnection = "closeOperatorConnection"
    case operatorConnectionStatusChanged = "operatorConnectionStatusChanged"
}
