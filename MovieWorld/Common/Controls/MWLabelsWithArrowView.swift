//
//  MWLabelsWithArrowView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/24/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWLabelsWithArrowView: UIView {

    var title: String = "" {
        didSet {
            self.titleLabel.text = self.title
        }
    }

    var value: String = "" {
        didSet {
            self.valueLabel.text = self.value
        }
    }

    var hasArrow: Bool = true {
        didSet {
            self.arrowImage.isHidden = !self.hasArrow
            self.valueLabel.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().inset(self.edgeInsets.right)
            }
        }
    }

    private let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 15)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.text = self.title
        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.textColor = .gray
        label.lineBreakMode = .byTruncatingTail
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.text = self.value
        return label
    }()

    private lazy var arrowImage: UIImageView = {
        let view: UIImageView = UIImageView()
        view.image = UIImage(named: "nextArrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        self.addSubview(self.valueLabel)
        self.addSubview(self.arrowImage)
    }

    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(self.edgeInsets.top)
            make.left.equalToSuperview().offset(self.edgeInsets.left)
            make.bottom.equalToSuperview().inset(self.edgeInsets.bottom)
        }

        self.valueLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(self.edgeInsets.top)
            make.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(self.edgeInsets.left)
            make.right.equalTo(self.arrowImage.snp.left)
            make.bottom.equalToSuperview().inset(self.edgeInsets.bottom)
        }

        self.arrowImage.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(self.edgeInsets.top)
            make.right.equalToSuperview().inset(self.edgeInsets.right)
            make.bottom.equalToSuperview().inset(self.edgeInsets.bottom)
        }

        super.updateConstraints()
    }
}
