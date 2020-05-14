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

    var buttonIsTapped: (() -> Void)?

    //MARK:- gui variables

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private lazy var showAllButton: MWCustomButton = {
        let button = MWCustomButton()
        button.addTarget(self, action: #selector(self.showAllButtonDidTapped), for: .touchUpInside)
        return button
    }()

    //MARK: - initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.label)
        self.addSubview(self.showAllButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    override func updateConstraints() {
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
        guard let buttonIsTapped = self.buttonIsTapped else { return }
        buttonIsTapped()
    }
}
