//
//  UITableView+Extensions.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 18/11/22.
//

import UIKit

extension UITableView {
    func registerCell<T>(_ type: T.Type, useNib: Bool = false) where T: UITableViewCell {
        let cellName = T.defaultReuseIdentifier
        
        if useNib {
            let nibCell = UINib(nibName: cellName, bundle: nil)
            register(nibCell, forCellReuseIdentifier: cellName)
            
        } else {
            register(T.self, forCellReuseIdentifier: cellName)
        }
    }
    
    func dequeueReusableCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        let cellName = T.defaultReuseIdentifier
        
        guard let cell = dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with Identifier: \(cellName)")
        }
        
        return cell
    }
}
