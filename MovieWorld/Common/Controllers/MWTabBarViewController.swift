//
//  MWTabBarViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/21/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWTabBarViewController: UITabBarController {

    private lazy var mainTabBarItem: UITabBarItem = {
        let view: UITabBarItem = UITabBarItem(
            title: "Main".local(),
            image: UIImage(named: "mainTabIcon"), selectedImage: UIImage(named: "mainTabIcon"))
        return view
    }()

    private lazy var categoryTabBarItem: UITabBarItem = {
        let view: UITabBarItem =  UITabBarItem(
            title: "Category".local(),
            image: UIImage(named: "categoryTabIcon"), selectedImage: UIImage(named: "categoryTabIcon"))
        return view
    }()

    private lazy var searchTabBarItem: UITabBarItem = {
        let view: UITabBarItem = UITabBarItem(
            title: "Search".local(),
            image: UIImage(named: "searchTabIcon"), selectedImage: UIImage(named: "searchTabIcon"))
        return view
    }()

    private lazy var profileTabBarItem: UITabBarItem = {
        let view: UITabBarItem = UITabBarItem(
            title: "Profile".local(),
            image: UIImage(named: "profileTabBarIcon"), selectedImage: UIImage(named: "profileTabBarIcon"))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupVC()
    }

    private func setupVC() {
        let mainVC = MWMainTabViewController()
        let categoryVC = MWCategoryViewController()
        let searchVC = MWSearchViewController()
        let profileVC = MWProfileViewController()

        mainVC.tabBarItem = self.mainTabBarItem
        categoryVC.tabBarItem = self.categoryTabBarItem
        searchVC.tabBarItem = self.searchTabBarItem
        profileVC.tabBarItem = self.profileTabBarItem

         self.viewControllers = [mainVC, categoryVC, searchVC, profileVC]
            .map{ MWNavigationController(rootViewController: $0) }

        self.setUpTabBarStyle()
    }

    private func setUpTabBarStyle() {
        self.tabBar.isTranslucent = false
        self.tabBar.layer.masksToBounds = false
        self.tabBar.tintColor = UIColor(named: "accentColor")
        self.tabBar.unselectedItemTintColor = UIColor(named: "mainColor")
    }
}
