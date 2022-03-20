//
//  File.swift
//  
//
//  Created by User on 14.03.2021.
//

import Foundation

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
}
