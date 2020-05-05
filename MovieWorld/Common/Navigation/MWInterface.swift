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

    //MARK: - static variables

    static let s = MWInterface()

    //MARK: - private variables

    private lazy var tabBarViewController = MWTabBarViewController()
    private lazy var initController = MWInitController()

    //MARK: - private(set) gui variables

    private(set) weak var window: UIWindow?

    //MARK: - initialization

    private init() {}

    //MARK:- setup window actions

    func setup(window: UIWindow) {
        self.window = window
        self.window?.backgroundColor = .white

        self.setUpNavigationBarStyle()

        self.window?.rootViewController = self.initController
        self.window?.makeKeyAndVisible()
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

    func setUpTabBar() {
        self.window?.rootViewController = self.tabBarViewController
    }

    //MARK:- push/pop actions

    func pushVC(_ vc: UIViewController, animated: Bool = true) {
        (self.tabBarViewController.selectedViewController as? MWNavigationController)?.pushViewController(vc, animated: animated)
    }

    func popVC(animated: Bool = true) {
        (self.tabBarViewController.selectedViewController as? MWNavigationController)?.popViewController(animated: animated)
    }
}
