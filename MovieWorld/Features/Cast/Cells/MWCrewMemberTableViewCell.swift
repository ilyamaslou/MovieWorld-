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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - constraints

    override func updateConstraints() {
        self.contentView.addSubview(self.memberNameLabel)

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
