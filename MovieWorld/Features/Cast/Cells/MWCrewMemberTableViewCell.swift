//
//  MWCrewMemberTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCrewMemberTableViewCell: UITableViewCell {

    //MARK: - static variables

    static var reuseIdentifier: String = "MWCrewMemberTableViewCell"

    //MARK: - insets

    private let edgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)

    //MARK: - private variable

    private var crewMember: MWMovieCrewMember?

    //MARK:- gui variable

    private lazy var memberNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()

    //MARK: - initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.memberNameLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    override func updateConstraints() {
        self.memberNameLabel.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.edgeInsets)
            make.right.equalToSuperview()
        }

        super.updateConstraints()
    }

    //MARK:- setter

    func set(crewMember: MWMovieCrewMember?) {
        self.selectionStyle = .none
        self.crewMember = crewMember
        self.memberNameLabel.text = crewMember?.name
        self.setNeedsUpdateConstraints()
    }
}
