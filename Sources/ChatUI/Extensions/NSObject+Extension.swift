//
//  File.swift
//  
//
//  Created by User on 02.03.2021.
//

import Foundation

extension NSObject {
    
    var classIdentifierName: String {
        return String(describing: type(of: self))
    }
    
    class var classIdentifierName: String {
        return String(describing: self)
    }
    
}
