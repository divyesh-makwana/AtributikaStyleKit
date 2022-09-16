//
//  AtributikaStyleKitModels.swift
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

#if os(macOS)
    typealias Font = NSFont
    typealias Color = NSColor
#else
    typealias Font = UIFont
    typealias Color = UIColor
#endif

// MARK: State
enum State: String, Codable {
    case normal, disabled, highlighted
}

// MARK: Attribute
enum Attribute: Codable, Equatable {
    
    // MARK: Geometry
    struct Size: Codable, Equatable {
        let width: CGFloat
        let height: CGFloat
        
        init(width: CGFloat, height: CGFloat) {
            self.width = width
            self.height = height
        }
        
        // MARK: Size - Native value conversion
        func toNative() -> CGSize {
            return CGSize(width: width, height: height)
        }
    }
        
    // MARK: Color
    typealias ColorString = String
    
    // MARK: Font
    enum FontType: Codable, Equatable {
        
        enum TextStyle: String, Codable {
            case largeTitle, title1, title2, title3, headline, subheadline, body, callout, footnote, caption1, caption2
            
            @available(iOS 11, watchOS 5.0, macOS 11, *)
            @available(tvOS, unavailable)
            // MARK: TextStyle - Native value conversion
            func toNative() -> Font.TextStyle {
                switch self {
                case .largeTitle:   return .largeTitle
                case .title1:       return .title1
                case .title2:       return .title2
                case .title3:       return .title3
                case .headline:     return .headline
                case .subheadline:  return .subheadline
                case .body:         return .body
                case .callout:      return .callout
                case .footnote:     return .footnote
                case .caption1:     return .caption1
                case .caption2:     return .caption2
                }
            }
        }
        
        enum Weight: String, Codable {
            case ultraLight, thin, light, regular, medium, semibold, bold, heavy, black
        }
                        
        // Cases
        case custom(name: String, size: CGFloat)
        case preferred(textStyle: TextStyle, weight: Weight? = nil)
        
        // MARK: Internal structs for decoding
        private enum Coding {
            // Private structs
            struct Font: Codable, Equatable {
                let name: String
                let size: CGFloat
            }
            
            struct PreferredFont: Codable, Equatable {
                let textStyle: TextStyle
                let weight: Weight?
            }
        }
        
        // MARK: Initializers
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let font = try? container.decode(Coding.Font.self) {
                self = .custom(name: font.name, size: font.size)
            } else if let systemFont = try? container.decode(Coding.PreferredFont.self) {
                self = .preferred(textStyle: systemFont.textStyle, weight: systemFont.weight)
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Something went wrong while decoding Font"))
            }
        }
        
        // MARK: FontType - Native value conversion
        func toNative() -> Font {
            switch self {
            case .custom(let name, let size):
                switch name {
                case "system":
                    return Font.systemFont(ofSize: size)
                case "systemBold":
                    return Font.boldSystemFont(ofSize: size)
                case "systemItalic":
                    return Font.italicSystemFont(ofSize: size)
                default:
                    guard let font = Font(name: name, size: size) else { fatalError("Can't create font with name: \(name)") }
                    return font
                }
            // TODO: Add weight support
            case .preferred(let textStyle, _):
                #if os(tvOS)
                    fatalError("preferredFont is unavailable in tvOS")
                #elseif os(iOS) || os(watchOS)
                if #available(iOS 11.0, watchOS 5.0, macOS 11, *) {
                    return Font.preferredFont(forTextStyle: textStyle.toNative())
                } else {
                    fatalError("preferredFont only available in iOS 11.0+, watchOS 5.0+")
                }
                #elseif os(OSX)
                if #available(macOS 11.0, *) {
                    return Font.preferredFont(forTextStyle: textStyle.toNative())
                } else {
                    fatalError("preferredFont only available in macOS 11.0+")
                }
                #endif
                
            }
        }
    }
    
    // MARK: Text Allignment
    enum TextAlignment: String, Codable {
        case left, center, right, justified, natural
        
        // MARK: TextAlignment - Native value conversion
        func toNative() -> NSTextAlignment {
            switch self {
            case .left:         return .left
            case .center:       return .center
            case .right:        return .right
            case .justified:    return .justified
            case .natural:      return .natural
            }
        }
    }
    
    // MARK: Line Break Mode
    enum LineBreakMode: String, Codable {
        case byWordWrapping, byCharWrapping, byClipping, byTruncatingHead, byTruncatingTail, byTruncatingMiddle
        
        // MARK: LineBreakMode - Native value conversion
        func toNative() -> NSLineBreakMode {
            switch self {
            case .byWordWrapping:       return .byWordWrapping
            case .byCharWrapping:       return .byCharWrapping
            case .byClipping:           return .byClipping
            case .byTruncatingHead:     return .byTruncatingHead
            case .byTruncatingTail:     return .byTruncatingTail
            case .byTruncatingMiddle:   return .byTruncatingMiddle
            }
        }
    }
    
    // MARK: Writing Direction
    enum WritingDirection: String, Codable {
        case natural, leftToRight, rightToLeft
        
        // MARK: WritingDirection - Native value conversion
        func toNative() -> NSWritingDirection {
            switch self {
            case .natural:      return .natural
            case .leftToRight:  return .leftToRight
            case .rightToLeft:  return .rightToLeft
            }
        }
    }
    
    // MARK: Paragraph Style
    struct ParagraphStyle: Codable, Equatable {
                
        enum LineBreakStrategy: String, Codable {
            case pushOut, hangulWordPriority, standard
            
            // MARK: ParagraphStyle - Native value conversion
            func toNative() -> NSParagraphStyle.LineBreakStrategy {
                switch self {
                case .pushOut:
                    if #available(iOS 9.0, macOS 10.11, *) {
                        return .pushOut
                    } else {
                        fatalError("LineBreakStrategy = pushOut only available in iOS 9.0+, macOS 11.0+")
                    }
                    
                case .hangulWordPriority:
                    if #available(iOS 14.0, watchOS 7.0, tvOS 14.0, macOS 11.0, *) {
                        return .hangulWordPriority
                    } else {
                        fatalError("LineBreakStrategy = hangulWordPriority only available in iOS 14.0+, watchOS 7.0+, tvOS 14.0+, macOS 11.0+")
                    }
                case .standard:
                    if #available(iOS 14.0, watchOS 7.0, tvOS 14.0, macOS 11.0, *) {
                        return .standard
                    } else {
                        fatalError("LineBreakStrategy = standard only available in iOS 14.0+, watchOS 7.0+, tvOS 14.0+, macOS 11.0+")
                    }
                }
            }
        }
        
        var lineSpacing: CGFloat? = nil
        var paragraphSpacing: CGFloat? = nil
        var alignment: TextAlignment? = nil
        var firstLineHeadIndent: CGFloat? = nil
        var headIndent: CGFloat? = nil
        var tailIndent: CGFloat? = nil
        var lineBreakMode: LineBreakMode? = nil
        var minimumLineHeight: CGFloat? = nil
        var maximumLineHeight: CGFloat? = nil
        var baseWritingDirection: WritingDirection? = nil
        var lineHeightMultiple: CGFloat? = nil
        var paragraphSpacingBefore: CGFloat? = nil
        var hyphenationFactor: Float? = nil
        var usesDefaultHyphenation: Bool? = nil
        var defaultTabInterval: CGFloat? = nil
        var allowsDefaultTighteningForTruncation: Bool? = nil
        var lineBreakStrategy: LineBreakStrategy? = nil
        
        init() {}
        
        // MARK: ParagraphStyle - Native value conversion
        func toNative() -> NSParagraphStyle {
            let style = NSMutableParagraphStyle()
                    
            if let lineSpacing = lineSpacing {
                style.lineSpacing = lineSpacing
            }
            
            if let paragraphSpacing = paragraphSpacing {
                style.paragraphSpacing = paragraphSpacing
            }
            
            if let alignment = alignment {
                style.alignment = alignment.toNative()
            }
            
            if let firstLineHeadIndent = firstLineHeadIndent {
                style.firstLineHeadIndent = firstLineHeadIndent
            }
            
            if let headIndent = headIndent {
                style.headIndent = headIndent
            }
            
            if let tailIndent = tailIndent {
                style.tailIndent = tailIndent
            }
            
            if let lineBreakMode = lineBreakMode {
                style.lineBreakMode = lineBreakMode.toNative()
            }
            
            if let minimumLineHeight = minimumLineHeight {
                style.minimumLineHeight = minimumLineHeight
            }
            
            if let maximumLineHeight = maximumLineHeight {
                style.maximumLineHeight = maximumLineHeight
            }
            
            if let baseWritingDirection = baseWritingDirection {
                style.baseWritingDirection = baseWritingDirection.toNative()
            }
            
            if let lineHeightMultiple = lineHeightMultiple {
                style.lineHeightMultiple = lineHeightMultiple
            }
            
            if let paragraphSpacingBefore = paragraphSpacingBefore {
                style.paragraphSpacingBefore = paragraphSpacingBefore
            }
            
            if let hyphenationFactor = hyphenationFactor {
                style.hyphenationFactor = hyphenationFactor
            }
            
            if #available(iOS 15.0, watchOS 8.0, tvOS 15.0, macOS 12.0, *) {
                if let usesDefaultHyphenation = usesDefaultHyphenation {
                    style.usesDefaultHyphenation = usesDefaultHyphenation
                }
            }
            
            if let defaultTabInterval = defaultTabInterval {
                style.defaultTabInterval = defaultTabInterval
            }
            
            if #available(macOS 10.11, *) {
                if let allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation {
                    style.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
                }
                
                if let lineBreakStrategy = lineBreakStrategy {
                    style.lineBreakStrategy = lineBreakStrategy.toNative()
                }
            }
            
            return style
        }
    }
    
    // MARK: Underline
    struct Underline: Codable, Equatable {
        
        enum Style: String, Codable {
            case single, thick, double, patternDot, patternDash, patternDashDot, patternDashDotDot, byWord
            
            func toNative() -> NSUnderlineStyle {
                switch self {
                case .single:               return .single
                case .thick:                return .thick
                case .double:               return .double
                case .patternDot:           return .patternDot
                case .patternDash:          return .patternDash
                case .patternDashDot:       return .patternDashDot
                case .patternDashDotDot:    return .patternDashDotDot
                case .byWord:               return .byWord
                }
            }
        }
        
        let style: Style
        let color: ColorString
        
        init(style: Underline.Style, color: ColorString) {
            self.style = style
            self.color = color
        }
    }
    
    // MARK: Strikethrough
    struct Strikethrough: Codable, Equatable {
        let style: Underline.Style
        let color: ColorString
        
        init(style: Underline.Style, color: ColorString) {
            self.style = style
            self.color = color
        }
    }
    
    // MARK: Stroke
    struct Stroke: Codable, Equatable {
        let color: ColorString
        let width: Float
        
        init(color: ColorString, width: Float) {
            self.color = color
            self.width = width
        }
    }
    
    // MARK: Shadow
    struct Shadow: Codable, Equatable {
        
        let offset: Size
        let blurRadius: CGFloat
        let color: ColorString?
        
        init(offset: Size, blurRadius: CGFloat, color: ColorString? = nil) {
            self.offset = offset
            self.blurRadius = blurRadius
            self.color = color
        }
        
        #if !os(watchOS)
        // MARK: Shadow - Native value conversion
        func toNative() -> NSShadow {
            let shadow = NSShadow()
            shadow.shadowOffset = offset.toNative()
            shadow.shadowBlurRadius = blurRadius
            
            // set asset catalog named or hex
            if let color = color {
                shadow.shadowColor = Color(named: color) ?? Color(hex: color)
            }
            
            return shadow
        }
        #endif
    }
    
    // Cases
    case font(FontType)
    case paragraphStyle(ParagraphStyle)
    case foregroundColor(ColorString)
    case backgroundColor(ColorString)
    case ligature(Int)
    case kern(Float)
    case strikethrough(Strikethrough)
    case underline(Underline)
    case stroke(Stroke)
    #if !os(watchOS)
    case shadow(Shadow)
    #endif
    case textEffect(String)
    case link(String)
    case baselineOffset(Float)
    case obliqueness(Float)
    case expansion(Float)
    case writingDirection(WritingDirection)
}

// MARK: Attributes
// The purpose of this class is to store dict to an attributes array and act as a sequence
struct Attributes: Codable, Equatable, Sequence {
    
    let attributes: [Attribute]
    func makeIterator() -> AttributeIterator {
        return AttributeIterator(attributes)
    }
    
    // MARK: Internal structs for decoding
    private enum Coding {
        // Private structs
        enum Keys: String, CodingKey {
            case attributes, font, paragraphStyle, foregroundColor, backgroundColor, ligature, kern, strikethrough, underline, stroke, shadow, textEffect, link, baselineOffset, obliqueness, expansion, writingDirection
        }
    }
    
    // MARK: Attribute Iterator
    struct AttributeIterator: IteratorProtocol {

        private let values: [Attribute]
        private var index: Int?

        init(_ values: [Attribute]) {
            self.values = values
        }

        private func nextIndex(for index: Int?) -> Int? {
            if let index = index, index < self.values.count - 1 {
                return index + 1
            }
            if index == nil, !self.values.isEmpty {
                return 0
            }
            return nil
        }

        mutating func next() -> Attribute? {
            if let index = self.nextIndex(for: self.index) {
                self.index = index
                return self.values[index]
            }
            return nil
        }
    }
    
    // MARK: Initializers
    init(_ attributes: [Attribute]) {
        self.attributes = attributes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Coding.Keys.self)
        
        var attr = [Attribute]()
        
        if let font = try container.decodeIfPresent(Attribute.FontType.self, forKey: .font) {
            attr.append(.font(font))
        }
        
        if let paragraphStyle = try container.decodeIfPresent(Attribute.ParagraphStyle.self, forKey: .paragraphStyle) {
            attr.append(.paragraphStyle(paragraphStyle))
        }
        
        if let color = try container.decodeIfPresent(Attribute.ColorString.self, forKey: .foregroundColor) {
            attr.append(.foregroundColor(color))
        }
        
        if let color = try container.decodeIfPresent(Attribute.ColorString.self, forKey: .backgroundColor) {
            attr.append(.backgroundColor(color))
        }
        
        if let ligature = try container.decodeIfPresent(Int.self, forKey: .ligature) {
            attr.append(.ligature(ligature))
        }
        
        if let kern = try container.decodeIfPresent(Float.self, forKey: .kern) {
            attr.append(.kern(kern))
        }
        
        if let strikethrough = try container.decodeIfPresent(Attribute.Strikethrough.self, forKey: .strikethrough) {
            attr.append(.strikethrough(strikethrough))
        }
        
        if let underline = try container.decodeIfPresent(Attribute.Underline.self, forKey: .underline) {
            attr.append(.underline(underline))
        }
        
        if let stroke = try container.decodeIfPresent(Attribute.Stroke.self, forKey: .stroke) {
            attr.append(.stroke(stroke))
        }
        
        if let shadow = try container.decodeIfPresent(Attribute.Shadow.self, forKey: .shadow) {
            attr.append(.shadow(shadow))
        }
        
        if let textEffect = try container.decodeIfPresent(String.self, forKey: .textEffect) {
            attr.append(.textEffect(textEffect))
        }
        
        if let link = try container.decodeIfPresent(String.self, forKey: .link) {
            attr.append(.link(link))
        }
        
        if let baselineOffset = try container.decodeIfPresent(Float.self, forKey: .baselineOffset) {
            attr.append(.baselineOffset(baselineOffset))
        }
        
        if let obliqueness = try container.decodeIfPresent(Float.self, forKey: .obliqueness) {
            attr.append(.obliqueness(obliqueness))
        }
        
        if let expansion = try container.decodeIfPresent(Float.self, forKey: .expansion) {
            attr.append(.expansion(expansion))
        }
        
        if let writingDirection = try container.decodeIfPresent(Attribute.WritingDirection.self, forKey: .writingDirection) {
            attr.append(.writingDirection(writingDirection))
        }
        
        self.attributes = attr
    }
}

struct AtributikaStyleGroup: Codable, Equatable {
    let normal: Attributes
    let highlighted: Attributes?
    let disabled: Attributes?
    
    init(normal: Attributes, highlighted: Attributes? = nil, disabled: Attributes? = nil) {
        self.normal = normal
        self.highlighted = highlighted
        self.disabled = disabled
    }
    
    // MARK: Internal structs for decoding
    private enum Coding {
        // Private structs
        enum Keys: String, CodingKey {
            case normal, highlighted, disabled
        }
    }
    
    // MARK: Initializers
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: Coding.Keys.self)
        if let normal = try container.decodeIfPresent(Attributes.self, forKey: .normal) {
            self.normal = normal
            self.highlighted = try container.decodeIfPresent(Attributes.self, forKey: .highlighted)
            self.disabled = try container.decodeIfPresent(Attributes.self, forKey: .disabled)
            
        } else {
            let singleValueContainer = try decoder.singleValueContainer()
            if let attributes = try? singleValueContainer.decode(Attributes.self) {
                self.normal = attributes
                self.highlighted = nil
                self.disabled = nil
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Something went wrong"))
            }
        }
    }
}

struct AtributikaStyleModel: Codable, Equatable {

    struct TagStyleModel: Codable, Equatable {
        let name: String
        let attributes: AtributikaStyleGroup

        init(name: String, attributes: AtributikaStyleGroup) {
            self.name = name
            self.attributes = attributes
        }
    }

    let name: String
    let attributes: AtributikaStyleGroup
    let tagStyles: [TagStyleModel]?
    
    // MARK: Initializers
    init(name: String, attributes: AtributikaStyleGroup, tagStyles: [TagStyleModel]? = nil) {
        self.name = name
        self.attributes = attributes
        self.tagStyles = tagStyles
    }
}
