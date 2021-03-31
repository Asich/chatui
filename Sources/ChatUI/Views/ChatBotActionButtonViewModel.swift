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
        let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        
        let adjustedRect: CGRect
        if #available(iOS 13, *) {
            let fullRange = NSRange(0..<attributedText.length)
            var isPartiallyAttributed = false
            attributedText.enumerateAttributes(in: fullRange) { value, range, stop in
                if !NSEqualRanges(fullRange, range) {
                    isPartiallyAttributed = true
                    stop.pointee = true
                }
            }
            var options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
            if isPartiallyAttributed {
                options.formUnion(NSStringDrawingOptions.usesDeviceMetrics)
            }
            adjustedRect = attributedText.boundingRect(with: constraintBox,
                                                                            options: options,
                                                                            context: nil)
        } else {
            adjustedRect = attributedText.boundingRect(with: constraintBox,
                                                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                            context: nil)
        }

        return adjustedRect.size
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
