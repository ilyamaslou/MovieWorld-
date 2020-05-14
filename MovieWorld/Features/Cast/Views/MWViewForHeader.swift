//
//  MWViewForHeader.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/6/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWViewForHeader: UIView {

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
        self.addSubview(self.titleLabel)
        self.makeConstraints()
    }

    //MARK: - constraints

    private func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
