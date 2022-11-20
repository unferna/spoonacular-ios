//
//  NSMutableAttributedString+Extensions.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 20/11/22.
//

import UIKit

private enum ViewConfig {
    static func getBaselineOffset(style: Theme.LabelStyle) -> CGFloat {
        let fontLineHeight = style.textStyle.font.lineHeight
        let lineHeight = style.textStyle.lineHeight
        let baselineOffset = (lineHeight - fontLineHeight) / 2.0 / 2.0
        
        return baselineOffset
    }
    
    static func getParagraphStyle(style: Theme.LabelStyle, alignment: NSTextAlignment) -> NSMutableParagraphStyle {
        let lineHeight = style.textStyle.lineHeight
        
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.minimumLineHeight = lineHeight
        mutableParagraphStyle.maximumLineHeight = lineHeight
        mutableParagraphStyle.alignment = alignment
        
        return mutableParagraphStyle
    }
}

extension NSMutableAttributedString {
    /// Concatenate attributed string
    /// Reference: https://stackoverflow.com/a/37992022/11263377
    func text(_ value: String, style: Theme.LabelStyle, alignment: NSTextAlignment = .left, color: UIColor = .black, underlined: Bool = false) -> NSMutableAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: style.textStyle.font,
            .foregroundColor: color,
            .baselineOffset: ViewConfig.getBaselineOffset(style: style),
            .paragraphStyle: ViewConfig.getParagraphStyle(style: style, alignment: alignment)
        ]
        
        if underlined {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}
