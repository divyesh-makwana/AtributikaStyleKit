//
//  Color+HEX.swift
//  AtributikaStyleKit
//
//  Created by Divyesh Makwana on 9/8/22.
//  Copyright © 2022 AtributikaStyleKit. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

extension Color {
    
    convenience init(hex hexString: String) {
        var hex = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
        
        // change 3 char color to 6 char color
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }

        // we expect a 6 char color
        guard hex.count == 6, let color = Int(hex, radix: 16) else {
            // initiale with black
            self.init(hex: "000")
            return
        }
        
        let red = CGFloat((color >> 16 & 0xFF)) / 255.0
        let green = CGFloat((color >> 8 & 0xFF)) / 255.0
        let blue = CGFloat((color & 0xFF)) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
