//
//  File.swift
//  
//
//  Created by User on 02.03.2021.
//

import Foundation
import UIKit

public extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.module)
    }

    static func instantiate(autolayout: Bool = true) -> Self {
        // generic helper function
        func instantiateUsingNib<T: UIView>(autolayout: Bool) -> T {
            let view = self.nib.instantiate(withOwner: nil, options: nil).first as! T
            view.translatesAutoresizingMaskIntoConstraints = !autolayout
            return view
        }
        return instantiateUsingNib(autolayout: autolayout)
    }
}
