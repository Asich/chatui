//
//  ChatBotActionButton.swift
//  MyBeeline
//
//  Created by admin on 9/20/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import UIKit

class ChatBotActionButton: UIButton {
    
    enum UIType {
        case left
        case right
    }
    
    private let type: UIType
    let viewModel: ChatBotActionButtonViewModel
    
    override var intrinsicContentSize: CGSize {
        return viewModel.getSize()
    }
    
    init(frame: CGRect,
         type: UIType,
         viewModel: ChatBotActionButtonViewModel) {
        self.type = type
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.alpha = 1
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lighterBlue.cgColor
        setTitleColor(.lightBlueColor, for: .normal)
        setTitleColor(.lightBlueColor, for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        backgroundColor = .clear
        setTitle(viewModel.title, for: .normal)
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.textAlignment = .center
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        guard type == .left else { return }
            if #available(iOS 11, *) {
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                return
            }
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: [.bottomLeft, .bottomRight, .topRight],
                                      cornerRadii: CGSize(width: frame.width, height: frame.height)).cgPath
        layer.mask = rectShape
    }
}
