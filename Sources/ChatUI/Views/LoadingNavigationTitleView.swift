//
//  File.swift
//  
//
//  Created by ainur on 27.03.2021.
//

import Foundation
import UIKit

class LoadingNavigationTitleView: UIStackView {
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.color = .gray
        indicator.snp.makeConstraints { $0.size.equalTo(20) }
        indicator.startAnimating()
        return indicator
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    init(title: String?) {
        super.init(frame: CGRect.zero)
        titleLabel.text = title
        addArrangedSubview(indicator)
        addArrangedSubview(titleLabel)
        spacing = 8
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
