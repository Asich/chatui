//
//  ChatBotActionMessagesFlowLayout.swift
//  MyBeeline
//
//  Created by admin on 9/17/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import MessageKit
import UIKit

class ChatBotActionMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    
    lazy open var sizeCalculator = ChatBotActionMessageSizeCalculator(layout: self)
    
    open override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            return sizeCalculator
        }
        
        return super.cellSizeCalculatorForItem(at: indexPath)
    }
    
    open override func messageSizeCalculators() -> [MessageSizeCalculator] {
        var superCalculators = super.messageSizeCalculators()
        // Append any of your custom `MessageSizeCalculator` if you wish for the convenience
        // functions to work such as `setMessageIncoming...` or `setMessageOutgoing...`
        superCalculators.append(sizeCalculator)
        return superCalculators
    }
}
