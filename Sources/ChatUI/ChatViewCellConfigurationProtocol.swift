//
//  File.swift
//  
//
//  Created by User on 22.03.2021.
//

import Foundation
import UIKit

public protocol ChatViewCellConfigurationProtocol {
    var backgroundColor: UIColor? { get }
    var textColor: UIColor? { get }
    var botImage: UIImage? { get }
    var operatorImage: UIImage? { get }
    var botMessageTitleText: String? { get }
    var botMessageSubtitleText: String? { get }
    var operatorMessageTitleText: String? { get }
    var operatorMessageSubtitleText: String? { get }
    var actionButtonsColor: UIColor? { get }
}

extension ChatViewCellConfigurationProtocol {
    public var backgroundColor: UIColor? { return .white }
    public var textColor: UIColor? { return .black }
    public var botImage: UIImage? { return UIImage(nameInModule: "chat_bot_beeline") }
    public var operatorImage: UIImage? { return UIImage(nameInModule: "operator") }
    public var botMessageTitleText: String? { return "Bot" }
    public var botMessageSubtitleText: String? { return "Bot" }
    public var operatorMessageTitleText: String? { return "Operator" }
    public var operatorMessageSubtitleText: String? { return "Operator" }
    public var actionButtonsColor: UIColor? { return .lighterBlue }
}

class DefaultCellConfiguration: ChatViewCellConfigurationProtocol {
    public init() {}
}

