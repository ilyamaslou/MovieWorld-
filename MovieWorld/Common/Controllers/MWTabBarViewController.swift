//
//  MWTabBarViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/21/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWTabBarViewController: UITabBarController {
    
    lazy var mainTabBarItem: UITabBarItem = {
        let view: UITabBarItem = UITabBarItem(
            title: "Main",
            image: UIImage(named:"mainTabIcon"), selectedImage: UIImage(named:"mainTabIcon"))
        return view
    }()
    
    lazy var categoryTabBarItem: UITabBarItem = {
        let view: UITabBarItem =  UITabBarItem(
            title: "Category",
            image: UIImage(named:"categoryTabIcon"), selectedImage: UIImage(named:"categoryTabIcon"))
        return view
    }()
    
    lazy var searchTabBarItem: UITabBarItem = {
        let view: UITabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(named:"searchTabIcon"), selectedImage: UIImage(named:"searchTabIcon"))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    private func setupVC() {
        let mainVC = MWMainTabViewController()
        let categoryVC = MWCategoryViewController()
        let searchVC = MWSearchViewController()
        
        mainVC.tabBarItem = self.mainTabBarItem
        categoryVC.tabBarItem = self.categoryTabBarItem
        searchVC.tabBarItem = self.searchTabBarItem
        
         self.viewControllers = [mainVC, categoryVC , searchVC]
            .map{MWNavigationController(rootViewController: $0)}
        
        self.tabBar.isTranslucent = false
        self.tabBar.layer.masksToBounds = false
        self.tabBar.tintColor = UIColor(named: "accentColor")
        self.tabBar.unselectedItemTintColor = UIColor(named: "mainColor")
    }
}
