//
//  MWCastMemberTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastMemberTableViewCell: UITableViewCell {

    //MARK: - static variable

    static var reuseIdentifier: String = "MWCastMemberTableViewCell"

    //MARK:- gui variable

    private lazy var castMemberView = MWCastMemberView()

    // MARK: - constraints

    override func updateConstraints() {
        self.contentView.addSubview(self.castMemberView)
        self.castMemberView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }

    //MARK:- setter

    func set(castMember: MWMovieCastMember?) {
        self.castMemberView.set(castMember: castMember)
        self.setNeedsUpdateConstraints()
        self.layoutIfNeeded()
    }
}
