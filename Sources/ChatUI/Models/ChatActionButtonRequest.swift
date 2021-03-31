//
//  ChatActionButtonRequest.swift
//  MyBeeline
//
//  Created by admin on 10/22/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import Foundation

public struct ChatActionButtonRequest: Codable {
    
    let action: String
    let schemaId: String
    let requestId: String
    let stepId: Int
    let buttonId: String
    
    public init(buttonModel: ChatActionButtonModel, requestId: String) {
        action = "buttonClick"
        schemaId = buttonModel.schemaId
        self.requestId = requestId
        stepId = buttonModel.stepId
        buttonId = buttonModel.buttonId
    }
}
