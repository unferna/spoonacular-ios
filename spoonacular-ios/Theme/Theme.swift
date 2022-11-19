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
    }
    
    enum Layout {
        static let basicHorizontalSpacing: CGFloat = 24
        static let basicInterItemSpacing: CGFloat = 16
    }
}
