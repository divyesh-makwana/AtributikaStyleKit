import Atributika

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

extension AtributikaStyleModel.TagStyleModel {
    func toStyle() -> Style {
        return attributes.append(to: Style(name))
    }
}

extension AtributikaStyleGroup {
    func append(to style: Style) -> Style {
        var style = style
        style = normal.append(to: style, state: .normal)
        
        if let highlighted = highlighted {
            style = highlighted.append(to: style, state: .highlighted)
        }
        
        if let disabled = disabled {
            style = disabled.append(to: style, state: .disabled)
        }
        
        return style
    }
}

extension Attributes {
    func append(to style: Style, state: StyleType) -> Style {
        var style = style
        for attribute in attributes {
            style = attribute.append(to: style, state: state)
        }
        return style
    }
}

fileprivate extension Attribute {
    func append(to style: Style, state: StyleType) -> Style {
        switch self {
        case .font(let font):
            return style.merged(with: Style.font(font.toNative(), state))
        case .paragraphStyle(let paragraphStyle):
            return style.merged(with: Style.paragraphStyle(paragraphStyle.toNative(), state))
        case .foregroundColor(let color):
            return style.merged(with: Style.foregroundColor(Color(hex: color), state))
        case .backgroundColor(let color):
            return style.merged(with: Style.backgroundColor(Color(hex: color), state))
        case .ligature(let ligature):
            return style.merged(with: Style.ligature(ligature, state))
        case .kern(let kern):
            return style.merged(with: Style.kern(kern, state))
        case .strikethrough(let strikethrough):
            let strikethroughStyle = Style.strikethroughStyle(strikethrough.style.toNative(), state)
                .strikethroughColor(Color(hex: strikethrough.color), state)
            return style.merged(with:strikethroughStyle)
        case .underline(let underline):
            let underlineStyle = Style.underlineStyle(underline.style.toNative(), state)
                .underlineColor(Color(hex: underline.color), state)
            return style.merged(with: underlineStyle)
        case .stroke(let stroke):
            let strokeStyle = Style.strokeColor(Color(hex: stroke.color), state)
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
