//
//  UIFont+Extensions.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import UIKit

extension UIFont {
    static func fromTheme(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        guard let font = font else {
            print("Font named \"\(name)\" does not exist in project")
            return UIFont.systemFont(ofSize: size)
        }
        
        return font
    }
}
