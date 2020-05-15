//
//  MWCountryFilterTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCountryFilterTableViewCell: UITableViewCell {

    //MARK: - static variables

    static var reuseIdentifier: String = "MWCountryFilterTableViewCell"

    //MARK: - variable

    var isCellSelected: Bool = false {
        didSet {
            self.checkImage.isHidden = !self.isCellSelected
        }
    }

    //MARK: - insets

    private let edgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 15)

    //MARK:- gui variables

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var checkImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "selectImage")
        return view
    }()

    //MARK: - initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubviews()
        self.makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    private func addSubviews() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.checkImage)
    }

    private func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.edgeInsets)
        }

        self.checkImage.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview().inset(self.edgeInsets)
            make.left.equalTo(self.titleLabel.snp.right)
        }
    }

    //MARK: - setters

    func set(country: (country: String?, isSelected: Bool)) {
        self.selectionStyle = .none
        self.titleLabel.text = country.country
        self.isCellSelected = country.isSelected
        self.setNeedsUpdateConstraints()
    }
}
