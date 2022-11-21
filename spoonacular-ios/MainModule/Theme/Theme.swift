//
//  Theme.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 18/11/22.
//

import UIKit

enum Theme {}

extension Theme {
    enum Colors {
        static let primary = UIColor(named: "primary")
        static let accent = UIColor(named: "accent")
        static let primaryText = UIColor(named: "primaryText")
        static let success = UIColor(named: "success")
    }
    
    enum Layout {
        /// 24pt
        static let basicHorizontalSpacing: CGFloat = 24
        /// 16pt
        static let basicInterItemSpacing: CGFloat = 16
        
        static let mediumVerticalSpacing: CGFloat = 12
    }
}


extension UILabel {
    func applyTextStyle(_ style: Theme.LabelStyle, ignoreLineHeight: Bool = false, alignment: NSTextAlignment = .left, color: UIColor? = nil) {
        font = style.textStyle.font
        numberOfLines = 0
        
        if !ignoreLineHeight {
            lineHeight = style.textStyle.lineHeight
        }

        textAlignment = alignment
        
        guard let color = color else { return }
        textColor = color
    }
}
