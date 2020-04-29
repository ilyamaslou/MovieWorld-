//
//  MWCastMemberTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastMemberTableViewCell: UITableViewCell {

    private lazy var castMemberView: MWCastMemberCellView = MWCastMemberCellView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.castMemberView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        self.castMemberView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }

    func set(castMember: MWMovieCastMember?) {
        self.castMemberView.set(castMember: castMember)
        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }
}
