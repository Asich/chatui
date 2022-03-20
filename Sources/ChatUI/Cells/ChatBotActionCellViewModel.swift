//
//  ChatBotActionCellViewModel.swift
//  MyBeeline
//
//  Created by admin on 9/20/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import Foundation
import UIKit

public final class ChatBotActionCellViewModel: Codable {
    
    var senderName: String {
        return sender.displayName
    }
    
    var senderType: String {
        return sender.type
    }
    
    public var text: String {
        response.response
    }

    public var senderImage: UIImage? {
        return UIImage(nameInModule: "operator")
    }

    public var message: NSMutableAttributedString? {
        let resultString = response.response.dropFirstAndLastParagraphTags()
        
        let attributedString = try? NSMutableAttributedString(HTMLString: "<span>\(resultString)</span>", font: UIFont.systemFont(ofSize: 16))
        return attributedString
        
    }
    
    var height: CGFloat = 100
    
    var buttonViewModels: [ChatBotActionButtonViewModel]
    
    private(set) var buttonsViewHeight: CGFloat = .zero
    
    var actionButtonStackViewsCount: Int {
        if buttonViewModels.count % 2 == 0 {
            return buttonViewModels.count / 2
        }
        
        return (buttonViewModels.count / 2) + 1
    }
    
    private(set) var response: ChatBotResponse
    private(set) var sender: SenderUser
    
    public init(response: ChatBotResponse, sender: SenderUser) {
        self.response = response
        self.sender = sender
        
        guard !response.buttons.isEmpty else {
            buttonViewModels = []
            setLabelHeight()
            return
        }
        
        buttonViewModels = response.buttons.map { ChatBotActionButtonViewModel(buttonModel: $0, requestId: UUID().uuidString) }
        setCorrectButtonsHeights()
        setLabelHeight()
    }
    
    enum CodingKeys: String, CodingKey {
        case response
        case sender
        case isLastMessage
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        response = try container.decode(ChatBotResponse.self, forKey: .response)
        sender = try container.decode(SenderUser.self, forKey: .sender)
        guard !response.buttons.isEmpty else {
            buttonViewModels = []
            setLabelHeight()
            return
        }
        
        buttonViewModels = response.buttons.map { ChatBotActionButtonViewModel(buttonModel: $0, requestId: UUID().uuidString) }
        setCorrectButtonsHeights()
        setLabelHeight()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(response, forKey: .response)
        try container.encode(sender, forKey: .sender)
    }
    
    func setLabelHeight() {
        guard let message = message else { return }
        let width: CGFloat = ((UIScreen.main.bounds.width * 4) / 5)
        height = getLabelSize(for: message, considering: width).height
    }
    
    private func getLabelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        let size = CGSize(width: maxWidth - 32, height: CGFloat.greatestFiniteMagnitude)
        let newSize = attributedText.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return newSize
    }
    
    private func setCorrectButtonsHeights() {
        for (i, buttonViewModel) in buttonViewModels.enumerated() {
            if i % 2 == 0 {
                guard i >= 0, i < buttonViewModels.count - 1 else {
                    buttonsViewHeight += buttonViewModel.getSize().height
                    return
                }
                let nextButtonViewModel = buttonViewModels[i + 1]
                if buttonViewModel.getSize().height < nextButtonViewModel.getSize().height {
                    buttonViewModel.updateButton(size: nextButtonViewModel.getSize())
                }
                
                buttonsViewHeight += buttonViewModel.getSize().height
            }
        }
           
        buttonsViewHeight += CGFloat((buttonViewModels.count - 1) * 8)
    }

}
