//
//  MainTabBarController.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 18/11/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    private lazy var homeNavigationController: UINavigationController = {
        let homeViewController = HomeViewController()
        
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.title = "Home"
        nav.setNavigationBarHidden(true, animated: false)
        return nav
    }()
    
    private lazy var myRecipesNavigationController: UINavigationController = {
        let homeViewController = MyRecipesViewController()
        
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.title = "My Recipes"
        nav.setNavigationBarHidden(true, animated: false)
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        viewControllers = [
            homeNavigationController,
            myRecipesNavigationController
        ]
        
        tabBar.backgroundColor = .white
    }
}
