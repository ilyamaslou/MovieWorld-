//
//  MWViewForHeader.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/6/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWViewForHeader: UIView {

    //MARK: - insets variable

    private var edgeInsets = UIEdgeInsets(top: 24, left: 16, bottom: .zero, right: 16)

    //MARK: - gui variable

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    //MARK: - initialization

    convenience init(title: String?) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.setUpView()
    }

    //MARK: - constraints

    private func setUpView() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(self.edgeInsets)
        }
    }
}
