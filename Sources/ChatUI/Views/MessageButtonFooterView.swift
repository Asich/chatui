//
//  MessageButtonFooterView.swift
//  MyBeeline
//
//  Created by admin on 11/18/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import UIKit
import MessageKit

class MessageButtonFooterView: MessageReusableView {

    @IBOutlet private weak var verticalStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        verticalStackView.snp.makeConstraints { make in
            make.width.equalTo((UIScreen.main.bounds.width * 4) / 5)
        }
    }
    
    func configure(viewModels: [ChatBotActionButtonViewModel]) {
        verticalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        setupActioButtons(viewModels: viewModels)
    }
    
    private func getNumberOfButtonsRows(viewModels: [ChatBotActionButtonViewModel]) -> Int {
        if viewModels.count % 2 == 0 {
            return viewModels.count / 2
        }
        
        return (viewModels.count / 2) + 1
    }
    
    private func setupActioButtons(viewModels: [ChatBotActionButtonViewModel]) {
        
        for _ in 0..<getNumberOfButtonsRows(viewModels: viewModels) {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.distribution = .fillProportionally
            verticalStackView.addArrangedSubview(stackView)
        }
        
        for (i, buttonViewModel) in viewModels.enumerated() {
            let index = i % 2 == 0 ? i / 2 : ((i - 1) / 2)
            let button = ChatBotActionButton(frame: .zero,
                                             type: i % 2 == 0 ? .left : .right,
                                             viewModel: buttonViewModel)
            button.addTarget(nil, action: #selector(ChatBotActionDelegate.actionDidPress(sender:)), for: .touchUpInside)
            guard let stackView = verticalStackView.arrangedSubviews[index] as? UIStackView else { return }
            stackView.addArrangedSubview(button)
            if i == viewModels.count - 1 && i % 2 == 0 {
                let spacer = ChatSpacer()
                stackView.addArrangedSubview(spacer)
            }
        }
    }
}

