//
//  ColorAdditions.swift
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
    
    class func from(_ colorString: String) -> Color {
        return (try? Color(named: colorString) ?? Color.standard(named: colorString)) ?? Color(hex: colorString)
    }
    
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
    
    class func standard(named: String) throws -> Color {
        switch named {
        case "systemBlue": return .systemBlue
        case "systemBrown":
            if #available(iOS 13.0, *) {
                return .systemBrown
            } else {
                throw NativeConversionError.standardColorNotFound(name: named)
            }
        case "systemCyan":
            if #available(iOS 15.0, macOS 12.0, *) {
                return .systemCyan
            } else {
                throw NativeConversionError.standardColorNotFound(name: named)
            }
        case "systemGray": return .systemGray
        #if !os(macOS)
        case "systemGray2":
            if #available(iOS 13.0, *) {
                return .systemGray2
            } else {
                throw NativeConversionError.standardColorNotFound(name: named)
            }
        case "systemGray3":
            if #available(iOS 13.0, *) {
                return .systemGray3
            } else {
                throw NativeConversionError.standardColorNotFound(name: named)
            }
        case "systemGray4":
            if #available(iOS 13.0, *) {
                return .systemGray4
            } else {
                throw NativeConversionError.standardColorNotFound(name: named)
            }
        case "systemGray5":
            if #available(iOS 13.0, *) {
                return .systemGray5
            } else {
                throw NativeConversionError.standardColorNotFound(name: named)
            }
        case "systemGray6":
            if #available(iOS 13.0, *) {
                return .systemGray6
            } else {
                throw NativeConversionError.standardColorNotFound(name: named)
            }
        #endif
        case "systemGreen": return .systemGreen
        case "systemIndigo":
            if #available(iOS 13.0, macOS 10.15, *) {
                return .systemIndigo
            } else {
                throw NativeConversionError.standardColorNotFound(name: named)
            }
        case "systemMint":
            if #available(iOS 15.0, *) {
                return .systemMint
            } else {
                throw NativeConversionError.standardColorNotFound(name: named)
            }
        case "systemOrange": return .systemOrange
        case "systemPink": return .systemPink
        case "systemPurple": return .systemPurple
        case "systemRed": return .systemRed
        case "systemTeal": return .systemTeal
        case "systemYellow": return .systemYellow

        case "clear": return .clear

        case "black": return .black
        case "blue": return .blue
        case "brown": return .brown
        case "cyan": return .cyan
        case "darkGray": return .darkGray
        case "gray": return .gray
        case "green": return .green
        case "lightGray": return .lightGray
        case "magenta": return .magenta
        case "orange": return .orange
        case "purple": return .purple
        case "red": return .red
        case "white": return .white
        case "yellow": return .yellow
        default:
            throw NativeConversionError.standardColorNotFound(name: named)
        }
        
    }
}
