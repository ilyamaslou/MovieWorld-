//
//  MWEmptyListLabel.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/6/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWEmptyListLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.text = "This list is empty".local()
        self.font = .systemFont(ofSize: 24, weight: .bold)
        self.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
