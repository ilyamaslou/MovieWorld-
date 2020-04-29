//
//  UINavigationController + ex.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/16/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

extension UINavigationController {
    func removeBorder() {
        self.navigationBar.backgroundColor = .white
        self.navigationBar.shadowImage = UIImage()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.shadowColor = nil
            appearance.backgroundColor = .white
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }
    }

    func setBorder() {
        self.navigationBar.backgroundColor = .clear
        self.navigationBar.shadowImage = nil
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.shadowColor = .lightGray
            appearance.backgroundColor = .clear
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
