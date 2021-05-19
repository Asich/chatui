//
//  File.swift
//  
//
//  Created by User on 22.03.2021.
//

import Foundation
import MessageKit
import UIKit

public protocol ChatViewProtocol: class {
    var presenter: ChatPresenterMessageDataSourceProtocol? { get set }
    func chatDidLoad()
    func reloadUI()
    func updateMessage(index: Int)
    func showEndChatButton()
    func hideEndChatButton()
    func showAttachButton()
    func hideAttachButton()
    func showActivityIndicator()
    func hideActivityIndicator()
    func showAlert(title: String, message: String)
}

public protocol ChatPresenterMessageDataSourceProtocol: class {
    var messagesCount: Int { get }
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func viewWillDeinit()
    func getCurrentSender() -> SenderType
    func getMessageForItem(at indexPath: IndexPath) -> MessageType
    func getNumberOfSections() -> Int
    func getMessageStatusForItem(at indexPath: IndexPath) -> ChatMessageStatus
    func userHasSent(message: String)
    func actionButtonWasPressed(viewModel: ChatBotActionButtonViewModel)
    func imageDidPick(image: UIImage)
    func handleDeeplink(url: String)
    func closeOperatorConnectionPressed()
}
