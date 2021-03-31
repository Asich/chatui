//
//  File.swift
//  
//
//  Created by User on 22.03.2021.
//

import Foundation
import UIKit

public protocol ChatViewConfigurationProtocol {
    var backgroundColor: UIColor? { get }
    var messagesTextColor: UIColor? { get }
    var navigationTitleText: String? { get }
    var navigationTitleLoadingText: String? { get }
    var navigationButtonText: String? { get }
    var cellConfiguration: ChatViewCellConfigurationProtocol? { get }
    var dateLabelText: DateLabel?  { get }
    var sendButtonImage: SendButtonImage? { get }
    var inputBarColor: InputBarColor? { get }
    var inputBarPlaceholderText: String? { get }
    var messageStatusText: MessageStatuses? { get }
}

extension ChatViewConfigurationProtocol {
    public var backgroundColor: UIColor? { return .expandedCellBG }
    public var messagesTextColor: UIColor? { return .black }
    public var navigationTitleText: String? { return "Чат" }
    public var navigationTitleLoadingText: String? { return "Соединение" }
    public var navigationButtonText: String? { return "Завершить" }
    public var cellConfiguration: ChatViewCellConfigurationProtocol? { return DefaultCellConfiguration() }
    public var dateLabelText: DateLabel? { return DateLabel(today: "Сегодня",
                                                            yesterday: "Вчера") }
    public var sendButtonImage: SendButtonImage? { return SendButtonImage(active: UIImage(nameInModule: "send_button_active"),
                                                                         inactive: UIImage(nameInModule: "send_button_inactive")) }
    public var inputBarColor: InputBarColor? { return InputBarColor(background: .white,
                                                                      textView: .expandedCellBG,
                                                                      text: .textBlackColor,
                                                                      placeholder: .unavailableGray) }
    public var inputBarPlaceholderText: String? { return "Сообщение" }
    public var messageStatusText: MessageStatuses? { return MessageStatuses(sending: "Отправка",
                                                                            sent: "Отправлено",
                                                                            failure: "Ошибка") }
}

public struct DateLabel {
    var today: String
    var yesterday: String

    public init(today: String, yesterday: String) {
        self.today = today
        self.yesterday = yesterday
    }
}

public struct SendButtonImage {
    var active: UIImage?
    var inactive: UIImage?
    
    public init(active: UIImage?, inactive: UIImage?) {
        self.active = active
        self.inactive = inactive
    }
}

public struct InputBarColor {
    var background: UIColor
    var textView: UIColor
    var text: UIColor
    var placeholder: UIColor
    
    public init(background: UIColor, textView: UIColor, text: UIColor, placeholder: UIColor) {
        self.background = background
        self.textView = textView
        self.text = text
        self.placeholder = placeholder
    }
}

public struct MessageStatuses {
    var sending: String
    var sent: String
    var failure: String

    public init(sending: String, sent: String, failure: String) {
        self.sending = sending
        self.sent = sent
        self.failure = failure
    }
}
