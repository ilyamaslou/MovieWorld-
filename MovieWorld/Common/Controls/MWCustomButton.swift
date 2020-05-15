//
//  MWCustomButton.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/25/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCustomButton: UIButton {

    //MARK: parameter

    override var isHighlighted: Bool {
        didSet {
            self.layer.opacity = isHighlighted ? 0.5 : 1
        }
    }

    //MARK: - initialization

    override init(frame: CGRect) {
        super.init(frame: frame )
        self.setUpButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpButton()
    }

    //MARK:- setup view action

    override func layoutSubviews() {
        super.layoutSubviews()

        let imageWidth = self.imageView?.frame.size.width
        let titleLabelWidth = self.titleLabel?.frame.size.width

        self.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        self.titleEdgeInsets = UIEdgeInsets(top: .zero, left: -((imageWidth ?? -4) + 4), bottom: .zero, right: (imageWidth ?? -4) + 4)
        self.imageEdgeInsets = UIEdgeInsets(top: .zero, left: titleLabelWidth ?? .zero, bottom: .zero, right: -(titleLabelWidth ?? .zero) - 4)
    }

    func setUpButton(title: String = "All".local(), hasArrow: Bool = true) {
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(named: "accentColor")
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.white, for: .highlighted)

        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 13)

        if hasArrow {
            self.setImage(UIImage(named: "nextIcon"), for: .normal)
            self.setImage(UIImage(named: "nextIcon"), for: .highlighted)
        } else {
            self.setImage(nil, for: .normal)
            self.setImage(nil, for: .highlighted)
        }

        self.setNeedsUpdateConstraints()
    }
}
