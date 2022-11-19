//
//  BasicViewController.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import UIKit

class BasicViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func setupSubviews() { }
    
    func commonInit() {
        setupSubviews()
    }
}

extension BasicViewController: BasicView {
    func showError(_ error: Error?) {
        
    }
}
