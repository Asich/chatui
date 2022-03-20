//
//  File.swift
//  
//
//  Created by User on 14.03.2021.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        let lang = UserDefaults.standard.string(forKey: "language") ?? "ru"
        guard let path = Bundle.module.path(forResource: lang, ofType: "lproj"),
              let bundle = Bundle(path: path) else { return self }
        let str = NSLocalizedString(self, bundle: bundle, comment: "")
        return str
    }
    
    public func dropFirstAndLastParagraphTags() -> String {
        let prefix = "<p>"
        let suffix = "</p>"
        let newLine = "\n"
        var string = self
        if string.hasPrefix(prefix) {
            string = String(string.dropFirst(prefix.count))
        }
        if string.hasSuffix(newLine) {
            string = String(string.dropLast(newLine.count))
        }
        if string.hasSuffix(suffix) {
            string = String(string.dropLast(suffix.count))
        }
        return string
    }
    
    var chatHtmlString: String {
        return String(format: "<span style=\"font-family: '-apple-system', 'SF Pro Display'; font-weight: regular; font-color: white; font-size: 16\">%@</span>", self)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        defaultHtmlToAttributedString()
    }

    func defaultHtmlToAttributedString(textColor: UIColor = UIColor.iziLabel) -> NSAttributedString? {
        guard let htmlData = NSString(string: self).data(using: String.Encoding.unicode.rawValue) else { return nil }
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData, options: options, documentAttributes: nil)

        guard let string = attributedString?.string else {
            return attributedString
        }
        let nsString = NSString(string: string)
        let nsRange = nsString.range(of: string)
        attributedString?.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: nsRange)
        return attributedString
    }
}
