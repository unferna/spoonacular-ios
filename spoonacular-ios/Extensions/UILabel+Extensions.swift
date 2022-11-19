//
//  UILabel+Extensions.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import UIKit

extension UILabel {
    var lineHeight: CGFloat? {
        get {
            let paragraphStyle = getAttribute(key: .paragraphStyle) as? NSParagraphStyle
            return paragraphStyle?.minimumLineHeight ?? font.lineHeight
        }
        
        set {
            let lineHeight = newValue ?? font.lineHeight
            let baselineOffset = (lineHeight - font.lineHeight) / 2.0 / 2.0
            
            let mutableParagraphStyle = NSMutableParagraphStyle()
            mutableParagraphStyle.minimumLineHeight = lineHeight
            mutableParagraphStyle.maximumLineHeight = lineHeight
            
            setAttribute(key: .baselineOffset, value: baselineOffset)
            setAttribute(key: .paragraphStyle, value: mutableParagraphStyle)
        }
    }
    
    func getAttribute(key: NSAttributedString.Key) -> Any? {
        attributedText?.attribute(key, at: 0, effectiveRange: .none)
    }
    
    func setAttribute(key: NSAttributedString.Key, value: Any) {
        let attributedString: NSMutableAttributedString
        
        if let currentAttrString = attributedText {
            attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            
        } else {
            attributedString = NSMutableAttributedString(string: text ?? "")
            text = nil
        }
        
        attributedString.addAttribute(
            key,
            value: value,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        attributedText = attributedString
    }
}
