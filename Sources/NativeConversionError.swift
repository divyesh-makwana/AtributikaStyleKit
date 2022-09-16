//
//  File.swift
//  
//
//  Created by Divyesh Makwana on 9/16/22.
//

import Foundation

enum NativeConversionError: LocalizedError {
    case customFontNotFound(name: String, size: CGFloat)
    case standardColorNotFound(name: String)
    
    var errorDescription: String? {
        switch self {
        case .customFontNotFound(let name, _):
            return NSLocalizedString("Font: \(name) not found", comment: "Font Not Found")
        case .standardColorNotFound(let name):
            return NSLocalizedString("Standard color: \(name) not found", comment: "Standard Color Not Found")
        }
    }
}
