//
//  UIViewController + Ex.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/6/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

extension MWViewController {
    func add(_ child: UIViewController) {
        self.addChild(child)
        self.contentView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func removeChild() {
        guard self.parent != nil else { return }
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
