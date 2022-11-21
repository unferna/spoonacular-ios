//
//  UITextView+Extensions.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 20/11/22.
//

import UIKit

extension UITextView {
    func setHtmlText(_ text: String?, theme: Theme.LabelStyle, color: UIColor = .black) {
        let italicFont = TextStyle(fontName: .italic, size: theme.textStyle.size, lineHeight: theme.textStyle.lineHeight).font
        guard let attributedString = text?.convertHtmlToAttributedStringWithCSS(font: theme.textStyle.font, italicFont: italicFont, bulletTextFont: theme.textStyle.font, csscolor: "#000") else {
            print("Couldn't extract the text from html string.\nElement: \(self)\n")
            return
        }
        
        self.attributedText = attributedString
    }
}
