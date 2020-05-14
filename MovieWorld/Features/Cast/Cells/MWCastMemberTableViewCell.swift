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

    //MARK: - initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.castMemberView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    override func updateConstraints() {
        self.castMemberView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }

    //MARK:- setter

    func set(castMember: MWMovieCastMember?) {
        self.selectionStyle = .none
        self.castMemberView.set(castMember: castMember)
        self.setNeedsUpdateConstraints()
    }
}
