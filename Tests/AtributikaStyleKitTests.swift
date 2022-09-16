import XCTest
@testable import AtributikaStyleKit

// MARK:- item test
class AtributikaStyleKitTests: XCTestCase {
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: Geometry
    func test_sizeModelDecoding_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "width": 100,
            "height": 100
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.Size.self, from: data)
        XCTAssertEqual(item, .init(width: 100, height: 100))
    }
    
    func test_sizeModelDecodingToCoreGraphics_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "width": 100,
            "height": 100
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.Size.self, from: data).toNative()
        XCTAssertEqual(item, .init(width: 100, height: 100))
    }
    
    // MARK: Font
    func test_fontModelDecoding_withCustomFontJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "name": "name",
            "size": 18
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.FontType.self, from: data)
        XCTAssertEqual(item, .custom(name: "name", size: 18))
    }
        
    func test_fontModelToNativeFontDecoding_withAvenirNextFontJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "name": "AvenirNext-Regular",
            "size": 18
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.FontType.self, from: data).toNative()
        XCTAssertEqual(item, .init(name: "AvenirNext-Regular", size: 18)!)
    }
    
    func test_fontModelToNativeFontDecoding_withSystemFontJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "name": "system",
            "size": 18
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.FontType.self, from: data).toNative()
        XCTAssertEqual(item, .systemFont(ofSize: 18))
    }
    
    func test_fontModelToNativeFontDecoding_withSystemBoldFontJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "name": "systemBold",
            "size": 18
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.FontType.self, from: data).toNative()
        XCTAssertEqual(item, .boldSystemFont(ofSize: 18))
    }
    
    func test_fontModelToNativeFontDecoding_withSystemItalicFontJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "name": "systemItalic",
            "size": 18
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.FontType.self, from: data).toNative()
        XCTAssertEqual(item, Font.italicSystemFont(ofSize: 18))
    }
    
    func test_fontModelDecoding_withPreferredFontJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "textStyle": "largeTitle",
            "weight": "ultraLight"
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.FontType.self, from: data)
        XCTAssertEqual(item, .preferred(textStyle: .largeTitle, weight: .ultraLight))
    }
    
    func test_fontModelDecoding_withPreferredFontAndOptionalWeightParamJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "textStyle": "largeTitle"
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.FontType.self, from: data)
        XCTAssertEqual(item, .preferred(textStyle: .largeTitle))
    }
    
    func test_fontModelToNativeFontDecoding_withPreferredFontJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "textStyle": "title1",
            "weight": "ultraLight"
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.FontType.self, from: data).toNative()
        XCTAssertEqual(item, .preferredFont(forTextStyle: .title1))
    }
        
    // MARK: Paragraph Style
    func test_paragraphStyleModelDecoding_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "lineSpacing": 20,
            "alignment": "center",
            "lineBreakMode": "byTruncatingHead",
            "baseWritingDirection": "rightToLeft",
            "allowsDefaultTighteningForTruncation": true,
            "lineBreakStrategy": "hangulWordPriority"
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.ParagraphStyle.self, from: data)
        
        var style = Attribute.ParagraphStyle()
        style.lineSpacing = 20
        style.alignment = .center
        style.lineBreakMode = .byTruncatingHead
        style.baseWritingDirection = .rightToLeft
        style.allowsDefaultTighteningForTruncation = true
        style.lineBreakStrategy = .hangulWordPriority
        XCTAssertEqual(item, style)
    }
    
    func test_paragraphStyleModelToNativeParagraphStyleDecoding_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "lineSpacing": 20,
            "alignment": "center",
            "lineBreakMode": "byTruncatingHead",
            "baseWritingDirection": "rightToLeft",
            "allowsDefaultTighteningForTruncation": true,
            "lineBreakStrategy": "hangulWordPriority"
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.ParagraphStyle.self, from: data).toNative()
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20
        style.alignment = .center
        style.lineBreakMode = .byTruncatingHead
        style.baseWritingDirection = .rightToLeft
        style.allowsDefaultTighteningForTruncation = true
        if #available(iOS 14.0, watchOS 7.0, tvOS 14.0, macOS 11.0, *) {
            style.lineBreakStrategy = .hangulWordPriority
        }
        XCTAssertEqual(item, style)
    }
    
    // MARK: Color
    func test_hexColorStringToNativeColorDecoding_withValidString_shouldBeTrue() throws {
        let hexString = "#FF0000"
        let item = Color(hex: hexString)
        XCTAssertEqual(item, Color.red)
    }
    
    // MARK: Underline
    func test_underlineModelDecoding_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "style": "patternDot",
            "color": "red"
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.Underline.self, from: data)
        XCTAssertEqual(item, .init(style: .patternDot, color: "red"))
    }
    
    // MARK: Strikethrough
    func test_strikethroughModelDecoding_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "style": "patternDot",
            "color": "red"
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.Strikethrough.self, from: data)
        XCTAssertEqual(item, .init(style: .patternDot, color: "red"))
    }
    
    // MARK: Stroke
    func test_strokeModelDecoding_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "color": "red",
            "width": 10
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.Stroke.self, from: data)
        XCTAssertEqual(item, .init(color: "red", width: 10))
    }
    
    // MARK: Shadow
    func test_shadowModelDecoding_withAllParametersAndWithValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "offset": {
                "width": 10,
                "height": 10
            },
            "blurRadius": 10,
            "color": "red"
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.Shadow.self, from: data)
        XCTAssertEqual(item, .init(offset: .init(width: 10, height: 10), blurRadius: 10, color: "red"))
    }
    
    func test_shadowModelDecoding_withoutColorParameterAndWithValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "offset": {
                "width": 10,
                "height": 10
            },
            "blurRadius": 10
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attribute.Shadow.self, from: data)
        XCTAssertEqual(item, .init(offset: .init(width: 10, height: 10), blurRadius: 10))
    }
    
    // MARK: Attributes Test
    func test_attributeFontDecoding_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "font": {
                "name": "name",
                "size": 18
            },
            "kern": 10
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(Attributes.self, from: data)
        XCTAssertEqual(item, .init([.font(.custom(name: "name", size: 18)), .kern(10)]))
    }
    
    // MARK: Attribute Tag Test
    func test_atributikaStylesModelDecoding_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "normal": {
                "font": {
                    "name": "name",
                    "size": 18
                },
                "kern": 10
            }
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(AtributikaStyleGroup.self, from: data)
        XCTAssertEqual(item, .init(normal: Attributes([.font(.custom(name: "name", size: 18)), .kern(10)])))
    }
    
    func test_atributikaStylesModelDecoding_withoutProvidingStateKeys_shouldBeTrue() throws {
        let JSON = """
        {
            "font": {
                "name": "name",
                "size": 18
            },
            "kern": 10
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(AtributikaStyleGroup.self, from: data)
        XCTAssertEqual(item, .init(normal: Attributes([.font(.custom(name: "name", size: 18)), .kern(10)])))
    }
    
    func test_atributikaStylesModelDecodingToAtributikaStyle_withoutProvidingStateKeys_shouldBeTrue() throws {
        let JSON = """
        {
            "font": {
                "name": "systemFont",
                "size": 18
            },
            "kern": 10
        }
        """
        
        let data = JSON.data(using: .utf8)!
        let style = try decoder.decode(AtributikaStyleGroup.self, from: data).toStyle()
        XCTAssertEqual(style.attributes[.font] as! Font, Font.systemFont(ofSize: 18))
        XCTAssertEqual(style.attributes[.kern] as! Float, 10)
        
    }
    
    func test_tagStylesModelDecoding_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "name": "tag",
            "attributes": {
                "font": {
                    "name": "name",
                    "size": 18
                },
                "kern": 10
            }
        }
        """

        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(AtributikaStyleModel.TagStyleModel.self, from: data)
        XCTAssertEqual(item,
            .init(name: "tag",
                  attributes: .init(normal: Attributes([.font(.custom(name: "name", size: 18)), .kern(10)]))
                 )
        )
    }
    
    func test_stylesModelDecoding_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "name": "menu-style",
            "attributes": {
                "font": {
                    "name": "name",
                    "size": 18
                },
                "kern": 10
            },
            "tagStyles": [
                {
                    "name": "tag",
                    "attributes": {
                        "foregroundColor": "red",
                        "underline": {
                            "style": "single",
                            "color": "red"
                        }
                    }
                }
            ]
        }
        """

        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(AtributikaStyleModel.self, from: data)
        XCTAssertEqual(item, .init(
            name: "menu-style",
            attributes: .init(normal: .init([.font(.custom(name: "name", size: 18)), .kern(10)])),
            tagStyles: [
                .init(name: "tag", attributes: .init(normal: .init([.foregroundColor("red"), .underline(.init(style: .single, color: "red"))])))
            ])
        )
    }
    
    func test_stylesModelDecoding_withoutTagStylesAndWithValidJSON_shouldBeTrue() throws {
        let JSON = """
        {
            "name": "menu-style",
            "attributes": {
                "font": {
                    "name": "name",
                    "size": 18
                },
                "kern": 10
            }
        }
        """

        let data = JSON.data(using: .utf8)!
        let item = try decoder.decode(AtributikaStyleModel.self, from: data)
        XCTAssertEqual(item, .init(
            name: "menu-style",
            attributes: .init(normal: .init([.font(.custom(name: "name", size: 18)), .kern(10)])))
        )
    }
    
    func test_atributikaStyleKitPreload_withValidJSON_shouldBeTrue() throws {
        let JSON = """
        [
            {
                "name": "menu-style",
                "attributes": {
                    "font": {
                        "name": "italic",
                        "size": 18
                    },
                    "kern": 10
                },
                "tagStyles": [
                    {
                        "name": "tag",
                        "attributes": {
                            "foregroundColor": "red",
                            "underline": {
                                "style": "single",
                                "color": "systemBlue"
                            }
                        }
                    }
                ]
            }
        ]
        """
        
        let shared = AtributikaStyleKit.shared
        try shared.preload(json: JSON)
        XCTAssertEqual(shared.styles.count, 1)
        
        let menuStyle = shared.styles["menu-style"]
        XCTAssertNotNil(menuStyle)
        
        if let menuStyle = menuStyle {
            XCTAssertEqual(menuStyle.name, "menu-style")
            XCTAssertEqual(menuStyle.all.attributes[.font] as! Font, Font.italicSystemFont(ofSize: 18))
            XCTAssertEqual(menuStyle.all.attributes[.kern] as! Float, 10)
            
            if let tags = menuStyle.tags {
                XCTAssertEqual(tags.count, 1)
                XCTAssertEqual(tags[0].name, "tag")
                XCTAssertEqual(tags[0].attributes[.foregroundColor] as! Color, Color.red)
                XCTAssertEqual(tags[0].attributes[.underlineStyle] as! Int, NSUnderlineStyle.single.rawValue)
                XCTAssertEqual(tags[0].attributes[.underlineColor] as! Color, Color.systemBlue)
            }
        }
    }
    
    func test_attributedTextStylingUsingKit_withValidJSON_shouldBeTrue() throws {
        let text = "Save <b>$1.00</b> on <b>any</b> order!"
        let JSON = """
        [
            {
                "name": "style",
                "attributes": {
                    "font": {
                        "name": "systemFont",
                        "size": 14
                    },
                    "foregroundColor": "red"
                },
                "tagStyles": [
                    {
                        "name": "b",
                        "attributes": {
                            "font": {
                                "name": "boldSystemFont",
                                "size": 14
                            }
                        }
                    }
                ]
            }
        ]
        """
        
        let shared = AtributikaStyleKit.shared
        try shared.preload(json: JSON)
        
        let good = try text.apply(style: "style").attributedString
        let goodReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [.font: Font.systemFont(ofSize: 14), .foregroundColor: Color.red])
        goodReference.addAttributes([.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(5, 5))
        goodReference.addAttributes([.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))
        
        XCTAssertEqual(good, goodReference)
    }
}
