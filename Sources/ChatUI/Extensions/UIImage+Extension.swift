//
//  File.swift
//  
//
//  Created by User on 14.03.2021.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(nameInModule: String) {
        self.init(named: nameInModule, in: Bundle.module, compatibleWith: nil)
    }
}
