//
//  File.swift
//  
//
//  Created by Divyesh Makwana on 9/15/22.
//

import Foundation

#if os(macOS)
import AppKit

extension Font {
    class func italicSystemFont(ofSize fontSize: CGFloat) -> Font {
        return NSFontManager.shared.convert(Font.systemFont(ofSize: fontSize), toHaveTrait: .italicFontMask)
    }
}

#endif
