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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var checkImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "selectImage")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.checkImage)

        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.edgeInsets.top)
            make.left.equalToSuperview().offset(self.edgeInsets.left)
            make.bottom.equalToSuperview().inset(self.edgeInsets.bottom)
        }

        self.checkImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.edgeInsets.top)
            make.left.equalTo(self.titleLabel.snp.right)
            make.right.equalToSuperview().inset(self.edgeInsets.right)
            make.bottom.equalToSuperview().inset(self.edgeInsets.bottom)
        }
    }

    //MARK: - setters

    func set(country: (country: String?, isSelected: Bool)) {
        self.titleLabel.text = country.country
        self.isCellSelected = country.isSelected
        self.setNeedsUpdateConstraints()
    }
}
