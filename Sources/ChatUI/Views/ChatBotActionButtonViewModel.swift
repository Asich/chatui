//
//  ChatBotActionButtonViewModel.swift
//  MyBeeline
//
//  Created by admin on 9/20/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import Foundation
import UIKit

public class ChatBotActionButtonViewModel {
    
    public var title: String {
        return buttonModel.name
    }
    
    public var request: ChatActionButtonRequest? {
        return ChatActionButtonRequest(buttonModel: buttonModel, requestId: requestId)
    }
    
    public var url: String? {
        return buttonModel.url
    }
    
    public var requestId: String
    private var buttonModel: ChatActionButtonModel
    private var buttonSize: CGSize = .zero
    
    init(buttonModel: ChatActionButtonModel, requestId: String) {
        self.buttonModel = buttonModel
        self.requestId = requestId
        setButtonSize()
    }
    
    private func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.attributedText = attributedText
        return label.sizeThatFits(label.frame.size)

    }
    
    private func setButtonSize() {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let attributedText = NSAttributedString(string: buttonModel.name, attributes: attributes)
        let messageWidth = ((UIScreen.main.bounds.width * 4) / 5)
        let buttonWidth = ((messageWidth / 2) - 4) - 8
        let buttonHeight = labelSize(for: attributedText, considering: buttonWidth).height + 8
        let correctHeight = buttonHeight <= 52 ? 52 : buttonHeight
        buttonSize = CGSize(width: buttonWidth, height: correctHeight)
    }
    
    func getSize() -> CGSize {
        return buttonSize
    }
    
    func updateButton(size: CGSize) {
        buttonSize = size
    }
}
