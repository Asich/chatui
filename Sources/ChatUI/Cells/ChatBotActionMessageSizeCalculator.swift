//
//  ChatBotActionMessageSizeCalculator.swift
//  MyBeeline
//
//  Created by admin on 9/17/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import MessageKit
import UIKit

class ChatBotActionMessageSizeCalculator: MessageSizeCalculator {
    
    private enum Constants {
        static let bottomInset: CGFloat = 16
        static let messageLabelFont = UIFont.systemFont(ofSize: 16)
        static let topInset: CGFloat = 16
        static let botTitleLabelHeight: CGFloat = 15
        static let botUserNameLabelHeight: CGFloat = 15
        static let spaceBetweenTitleAndUserName: CGFloat = 4
        static let spaceBetweenUserNameAndMessageLabel: CGFloat = 8
    }

    lazy var layoutCell = ChatBotActionCollectionViewCell()
    
    open override func messageContainerSize(for message: MessageType) -> CGSize {
        let width = ((UIScreen.main.bounds.width * 4) / 5)
        var height = CGFloat.zero
        switch message.kind {
        case .custom(let viewModel):
            guard let viewModel = viewModel as? ChatBotActionCellViewModel else { return .zero }
            height += Constants.topInset + Constants.botTitleLabelHeight + Constants.spaceBetweenTitleAndUserName  + Constants.botUserNameLabelHeight + Constants.spaceBetweenUserNameAndMessageLabel + Constants.bottomInset
            height += viewModel.height
        default:
            return .zero
        }

        return CGSize(width: width, height: height)
    }
}
