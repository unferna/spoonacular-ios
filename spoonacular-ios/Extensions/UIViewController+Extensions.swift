//
//  UIViewController+Extensions.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 18/11/22.
//

import UIKit

extension UIViewController {
    var firstKeyWindowInsets: UIEdgeInsets? {
        UIApplication.shared.firstKeyWindow?.safeAreaInsets
    }
    
    var basicDeviceTopInset: CGFloat {
        firstKeyWindowInsets?.top ?? 44
    }
}
