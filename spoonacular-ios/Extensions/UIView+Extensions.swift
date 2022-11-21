//
//  UIView+Extensions.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 18/11/22.
//

import UIKit


extension UIView {
    static var defaultReuseIdentifier: String {
        String(describing: self)
    }
    
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
    func addShadow(radius: CGFloat = 3, color: UIColor = UIColor.black, offset: CGSize = CGSize(width: 0.3, height: 1.3), opacity: CGFloat = 0.6) {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = Float(opacity)
        layer.masksToBounds = false
    }
    
    func removeShadow() {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
    }
}
