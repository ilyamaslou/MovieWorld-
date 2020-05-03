//
//  MWInterface.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

typealias MWI = MWInterface

class MWInterface {

    static let s = MWInterface()

    private(set) weak var window: UIWindow?

    private lazy var tabBarViewController = MWTabBarViewController()
    private lazy var initController = MWInitController()

    private init() {}

    func setup(window: UIWindow) {
        self.window = window
        self.window?.backgroundColor = .white

        self.setUpNavigationBarStyle()

        self.window?.rootViewController = self.initController
        self.window?.makeKeyAndVisible()
    }

    func pushVC(_ vc: UIViewController, animated: Bool = true) {
        (self.tabBarViewController.selectedViewController as? MWNavigationController)?.pushViewController(vc, animated: animated)
    }

    func popVC(animated: Bool = true) {
        (self.tabBarViewController.selectedViewController as? MWNavigationController)?.popViewController(animated: animated)
    }

    func setUpTabBar() {
        self.window?.rootViewController = self.tabBarViewController
    }

    private func setUpNavigationBarStyle() {
        let standartNavBar = UINavigationBar.appearance()
        standartNavBar.backgroundColor = .white
        standartNavBar.tintColor = UIColor(named: "accentColor")
        standartNavBar.prefersLargeTitles = true

        if #available(iOS 13.0, *) {
            let newNavBar = UINavigationBarAppearance()
            newNavBar.configureWithDefaultBackground()
            standartNavBar.scrollEdgeAppearance = newNavBar
        }
    }
}
