//
//  MWResetButton.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/14/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWResetButton: UIBarButtonItem {

    //MARK: - initialization

    init(target: AnyObject?, action: Selector?) {
        super.init()
        self.target = target
        self.action = action
        self.title = "Reset".local()
        self.style = .plain
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - update button action

    func updateResetButton(hasNewValues: Bool) {
        self.tintColor = hasNewValues ? UIColor(named: "accentColor") : UIColor(named: "shadowColor")
        self.isEnabled = hasNewValues ? true : false
    }
}
