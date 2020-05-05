//
//  MWTitleButtonView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/1/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWTitleButtonView: UIView {

    //MARK:-  variables

    var title: String? {
        didSet {
            self.label.text = self.title
        }
    }

    var titleSize: Int = 17 {
        didSet {
            self.label.font = .systemFont(ofSize: CGFloat(self.titleSize), weight: .bold)
        }
    }

    //MARK:- Later will be deleted

    var controllerToPushing: UIViewController?

    //MARK:- gui variables

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private lazy var showAllButton: MWCustomButton = {
        let button = MWCustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showAllButtonDidTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - constraints

    override func updateConstraints() {
        self.addSubview(self.label)
        self.addSubview(self.showAllButton)

        self.label.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }

        self.showAllButton.snp.updateConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.greaterThanOrEqualTo(self.label.snp.right)
        }

        super.updateConstraints()
    }

    //MARK:- Actions

    @objc private func showAllButtonDidTapped() {
        guard let controller = controllerToPushing else { return }
        MWI.s.pushVC(controller)
    }
}
