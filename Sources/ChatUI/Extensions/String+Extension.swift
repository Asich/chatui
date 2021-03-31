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
}
