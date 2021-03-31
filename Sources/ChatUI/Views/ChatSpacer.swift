//
//  ChatSpacer.swift
//  
//
//  Created by User on 02.03.2021.
//

import Foundation
import UIKit

class ChatSpacer: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 5, height: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
    }
}
