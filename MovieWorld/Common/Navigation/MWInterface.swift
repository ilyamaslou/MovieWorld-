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
    
    public static let s = MWInterface()
    
    private(set) weak var window: UIWindow?
    
    private lazy var tabBarViewController = MWTabBarViewController()
    
    private init() {}
    
    public func setup(window: UIWindow) {
        
        self.window = window
        
        self.setUpNavigationBarStyle()
        
        window.rootViewController = tabBarViewController
        window.makeKeyAndVisible()
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
    
    public func pushVC(_ vc: UIViewController, animated: Bool = true) {
        guard let navigationController = self.tabBarViewController.selectedViewController as? MWNavigationController else { return }
        navigationController.pushViewController(vc, animated: animated)
        
    }
    
    public func popVC(animated: Bool = true) {
        guard let navigationController = self.tabBarViewController.selectedViewController as? MWNavigationController else { return }
        navigationController.popViewController(animated: animated)
    }
    
}
