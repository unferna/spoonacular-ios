//
//  String+Extensions.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 21/11/22.
//

import UIKit

extension String {
    var convertHtmlToNSAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).trimNewLineCharacter()
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    /// This method format the Ordered & Unordered bullets with Font attributes and make them Bold.
    ///
    /// - Parameters:
    ///   - font: The UIFont object used to apply the font to html text.
    ///   - bulletTextFont: The UIFont object used to apply the font to unordered bullet text's.
    ///   - csscolor: The Color object used to apply the color to the whole html text.
    ///   - lineheight: An Int value, used to apply the line height to the whole html text.
    ///   - csstextalign: A string, used to set the text allignment for the whole html text.
    /// - Returns: This returns converted NSMutableAttributedString from HTML text after applying all requires styles.
    func convertHtmlToAttributedStringWithCSS(font: UIFont?, italicFont: UIFont? = nil, bulletTextFont: UIFont = Theme.LabelStyle.input.textStyle.font, csscolor: String = "#000", lineheight: Int = 5, csstextalign: String = "left") -> NSMutableAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        
        let italicFont = italicFont ?? TextStyle(fontName: .italic, size: 16, lineHeight: 16).font
        
        // This contains the HTML styles to apply margin space for bullets, apply font, font size, color.
        let modifiedString = """
            <style>
                html * {
                    font-family: '\(font.fontName)', '\(italicFont.fontName)';
                    font-size:\(font.pointSize)px;
                    color: \(csscolor);
                    line-height: \(font.pointSize + CGFloat(lineheight))px;
                    text-align: \(csstextalign);
                }
        
                ul li {
                    margin: 5px 10px;
                    font-size:\(bulletTextFont.pointSize)px;
                    line-height: \(bulletTextFont.lineHeight)px;
                }
        
                ol > li {
                    margin: 6px 12px;
                }
                
                ul {
                    list-style-type: disc;
                }
            </style>\(self.trimmingCharacters(in: .whitespacesAndNewlines))
        """
        
        guard let data = modifiedString.data(using: .utf8) else { return nil }
        
        do {
            
            let attribbutedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).trimNewLineCharacter()
            return attribbutedString
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    var isNumber: Bool {
        return self.range(
            of: "^[0-9]*$", // 1
            options: .regularExpression) != nil
    }
}

extension NSMutableAttributedString {
    
    /// This method is used to trim the newline character of the attributedString so that textview content padding are zero.
    ///
    /// - Returns: This returns NSMutableAttributedString after removing the respective Character.
    func trimNewLineCharacter() -> NSMutableAttributedString {
        /// For plain HTML text a new line will get add at start & end of the string. Removing that with the below code.
        let mutableString = self
        if let lastCharacter = string.last, lastCharacter == "\n" {
            mutableString.deleteCharacters(in: NSRange(location: (self.length - 1), length: 1))
        }
        if let lastCharacter = string.first, lastCharacter == "\n" {
            mutableString.deleteCharacters(in: NSRange(location: (0), length: 1))
        }
        return mutableString
    }
}
