//
//  MessageDateReusableView.swift
//  MyBeeline
//
//  Created by admin on 11/13/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import Foundation
import MessageKit
import UIKit

class MessageDateReusableView: MessageReusableView {
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    func configure(viewModel: MessageDateReusableViewModel) {
        dateLabel.text = viewModel.dateText
    }
}
