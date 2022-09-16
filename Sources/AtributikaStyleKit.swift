import Foundation
import Atributika

protocol StyleConvertible {
    func toStyle() -> Style
}

struct AtributikaStyle {
    let name: String
    let all: Style
    let tags: [Style]?
    
    init(name: String, all: Style, tags: [Style]?) {
        self.name = name
        self.all = all
        self.tags = tags
    }
    
    init(styleModel: AtributikaStyleModel) {
        self.name = styleModel.name
        self.all = styleModel.attributes.append(to: Style())
        self.tags = styleModel.tagStyles?.map { $0.toStyle() }
    }
}

extension AtributikaStyleModel.TagStyleModel: StyleConvertible {
    func toStyle() -> Style {
        return attributes.append(to: Style(name))
    }
}

extension AtributikaStyleGroup: StyleConvertible {
    
    func toStyle() -> Style {
        append(to: Style())
    }
    
    func append(to style: Style) -> Style {
        var style = style
        style = normal.append(to: style)
        
        if let highlighted = highlighted {
            style = highlighted.append(to: style, state: .highlighted)
        }
        
        if let disabled = disabled {
            style = disabled.append(to: style, state: .disabled)
        }
        
        return style
    }
}

extension Attributes: StyleConvertible {
    
    func toStyle() -> Style {
        append(to: Style())
    }
        
    func append(to style: Style, state: StyleType = .normal) -> Style {
        var style = style
        for attribute in attributes {
            style = attribute.append(to: style, state: state)
        }
        return style
    }
}

extension Attribute: StyleConvertible {
    
    func toStyle() -> Style {
        append(to: Style())
    }
        
    func append(to style: Style, state: StyleType = .normal) -> Style {
        switch self {
        case .font(let font):
            do {
                return style.merged(with: Style.font(try font.toNative(), state))
            } catch {
                return style
            }
        case .paragraphStyle(let paragraphStyle):
            return style.merged(with: Style.paragraphStyle(paragraphStyle.toNative(), state))
        case .foregroundColor(let color):
            return style.merged(with: Style.foregroundColor(Color.from(color), state))
        case .backgroundColor(let color):
            return style.merged(with: Style.backgroundColor(Color.from(color), state))
        case .ligature(let ligature):
            return style.merged(with: Style.ligature(ligature, state))
        case .kern(let kern):
            return style.merged(with: Style.kern(kern, state))
        case .strikethrough(let strikethrough):
            let strikethroughStyle = Style.strikethroughStyle(strikethrough.style.toNative(), state)
                .strikethroughColor(Color.from(strikethrough.color), state)
            return style.merged(with:strikethroughStyle)
        case .underline(let underline):
            let underlineStyle = Style.underlineStyle(underline.style.toNative(), state)
                .underlineColor(Color.from(underline.color), state)
            return style.merged(with: underlineStyle)
        case .stroke(let stroke):
            let strokeStyle = Style.strokeColor(Color.from(stroke.color), state)
                .strokeWidth(stroke.width, state)
            return style.merged(with: strokeStyle)
        #if !os(watchOS)
        case .shadow(let shadow):
            return style.merged(with: Style.shadow(shadow.toNative(), state))
        #endif
        case .textEffect(let textEffect):
            return style.merged(with: Style.textEffect(textEffect, state))
        case .link(let link):
            return style.merged(with: Style.link(link, state))
        case .baselineOffset(let baselineOffset):
            return style.merged(with: Style.baselineOffset(baselineOffset, state))
        case .obliqueness(let obliqueness):
            return style.merged(with: Style.obliqueness(obliqueness, state))
        case .expansion(let expansion):
            return style.merged(with: Style.expansion(expansion, state))
        case .writingDirection(let writingDirection):
            return style.merged(with: Style.writingDirection(writingDirection.toNative(), state))
        }
    }
}

// MARK: - AttributedTextProtocol
extension AttributedTextProtocol {
    func style(_ style: AtributikaStyle) -> AttributedText {
        if let tags = style.tags {
            return string.style(tags: tags).styleAll(style.all)
        } else {
            return string.styleAll(style.all)
        }
    }
    
    public func apply(style named: String) throws -> AttributedText {
        guard AtributikaStyleKit.shared.didPreload else { throw AtributikaStyleKitError.preloadRequired }
        guard let style = AtributikaStyleKit.shared.styles[named] else { throw AtributikaStyleKitError.styleNotFound(name: named) }
        return string.style(style)
    }
}

// MARK: - AtributikaStyleKitError
public enum AtributikaStyleKitError: LocalizedError {
    case preloadRequired
    case fileNotFound(name: String, bundle: Bundle)
    case styleNotFound(name: String)
    
    public var errorDescription: String? {
        switch self {
        case .preloadRequired:
            return NSLocalizedString("AtributikaStyleKit.shared.preload is required before apply styles with names", comment: "Preload Required")
        case .fileNotFound(let name, let bundle):
            return NSLocalizedString("File: \(name) not found in bundle path: \(bundle.bundlePath)", comment: "File Not Found")
        case .styleNotFound(let name):
            return NSLocalizedString("Style: \(name) not found in AtributikaStyleKit", comment: "Style Not Found")
        }
    }
}

// MARK: - AtributikaStyleKit
public class AtributikaStyleKit {
    
    var styles = [String: AtributikaStyle]()
    var didPreload = false
    
    static let shared = AtributikaStyleKit()
    private init() {}
    
    
    public class func preload() throws {
        try shared.preload()
    }
    
    public class func preload(withJsonFile named: String, bundle: Bundle = .main) throws {
        try shared.preload(withJsonFile: named, bundle: bundle)
    }
    
    public class func preload(withJsonResource path: String) throws {
        try shared.preload(withJsonResource: path)
    }
    
    public class func preload(json payload: String) throws {
        try shared.preload(json: payload)
    }
    
    // MARK: Instance methods
    public func preload() throws {
        try preload(withJsonFile: String(describing: AtributikaStyleKit.self))
    }
    
    public func preload(withJsonFile named: String, bundle: Bundle = .main) throws {
        let ext = named.hasSuffix(".json") ? nil : "json"
        guard let path = bundle.path(forResource: named, ofType: ext) else { throw AtributikaStyleKitError.fileNotFound(name: named, bundle: bundle) }
        try preload(withJsonResource: path)
    }
    
    public func preload(withJsonResource path: String) throws {
        try preload(json: try String(contentsOfFile: path))
    }
    
    public func preload(json payload: String) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let data = payload.data(using: .utf8)!
        let styleModels = try decoder.decode([AtributikaStyleModel].self, from: data)
        
        // clear previous styles
        styles.removeAll()
        for styleModel in styleModels {
            styles[styleModel.name] = .init(styleModel: styleModel)
        }
        
        // mark for preload
        didPreload = true
    }
}
