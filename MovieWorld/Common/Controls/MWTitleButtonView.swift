//
//  MWTitleButtonView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/1/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWTitleButtonView: UIView {

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

    var controllerToPushing: UIViewController?

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

    override init(frame: CGRect) {
        super.init(frame: frame )
        self.setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }

    private func setUpView() {
        self.addSubview(self.label)
        self.addSubview(self.showAllButton)

        self.label.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview()
        }

        self.showAllButton.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.greaterThanOrEqualTo(self.label.snp.right)
        }
    }

    @objc private func showAllButtonDidTapped() {
        guard let controller = controllerToPushing else { return }
        MWI.s.pushVC(controller)
    }
}
