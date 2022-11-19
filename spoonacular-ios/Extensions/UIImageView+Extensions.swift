//
//  UIImageView+Extensions.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(from url: URL?) {
        guard let url = url else {
            print("Invalid image url:")
            print(url ?? "Not url provided")
            return
        }
        
        kf.setImage(with: url, options: [
            .cacheOriginalImage,
            .transition(.fade(0.2))
        ])
    }
}
