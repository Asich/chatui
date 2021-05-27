//
//  File.swift
//  
//
//  Created by User on 02.03.2021.
//

import Foundation
import UIKit

extension UIColor {
    
    func hex(hashPrefix: Bool = true) -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let prefix = hashPrefix ? "#" : ""
        
        return String(format: "\(prefix)%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
    convenience init(hex string: String) {
        var hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        guard hex.count == 3 || hex.count == 6
        else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        guard let intCode = Int(hex, radix: 16) else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        
        self.init(
            red:   CGFloat((intCode >> 16) & 0xFF) / 255.0,
            green: CGFloat((intCode >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((intCode) & 0xFF) / 255.0, alpha: 1.0)
    }
    
    class var unavailableGray: UIColor {
        return .init(hex: "#BEC2CA")
    }

    class var lighterBlue: UIColor {
        .init(hex: "#B3DEFF")
    }

    class var lightBlueColor: UIColor {
        return UIColor(hex: "#2E83C5")
    }

    class var yellow2: UIColor {
        .init(hex: "#FFE000")
    }

    class var expandedCellBG: UIColor {
        return UIColor(hex: "#F7F8FB")
    }

    class var textBlackColor: UIColor {
        return UIColor(hex: "#13152D")
    }

    class var veryLightBlue: UIColor {
        return UIColor(hex: "#E4F3FF")
    }
    
    class var userMessageBG: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return #colorLiteral(red: 0.1462543607, green: 0.1466053426, blue: 0.1569623351, alpha: 1)
                } else {
                    return UIColor(hex: "#E4F3FF")
                }
            }
        } else {
            return UIColor(hex: "#E4F3FF")
        }
    }
}
