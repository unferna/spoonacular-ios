//
//  Typography.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import UIKit

enum FontName: String {
    case bold = "SourceSansPro-Bold"
    case italic = "SourceSansPro-Italic"
    case regular = "SourceSansPro-Regular"
    case semibold = "SourceSansPro-SemiBold"
}

struct TextStyle {
    let font: UIFont
    let size: CGFloat
    let lineHeight: CGFloat
    
    init(fontName: FontName, size: CGFloat, lineHeight: CGFloat) {
        self.font = UIFont.fromTheme(name: fontName.rawValue, size: size)
        self.size = size
        self.lineHeight = lineHeight
    }
}

extension Theme {
    enum LabelStyle {
        case screenTitle
        case headline
        case body
        case bodyBold
        case smallInformation
        case cardTitle
        case input
        case largeButton
        
        var textStyle: TextStyle {
            switch self {
            case .screenTitle:
                return TextStyle(fontName: .bold, size: 30, lineHeight: 20)
                
            case .headline:
                return TextStyle(fontName: .bold, size: 22, lineHeight: 20)
                
            case .body:
                return TextStyle(fontName: .regular, size: 14, lineHeight: 20)
                
            case .bodyBold:
                return TextStyle(fontName: .bold, size: 14, lineHeight: 20)
                
            case .smallInformation:
                return TextStyle(fontName: .semibold, size: 12, lineHeight: 20)
                
            case .cardTitle:
                return TextStyle(fontName: .bold, size: 16, lineHeight: 20)
                
            case .input:
                return TextStyle(fontName: .regular, size: 16, lineHeight: 26)
                
            case .largeButton:
                return TextStyle(fontName: .bold, size: 16, lineHeight: 20)
            }
        }
    }
}
