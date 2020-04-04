//
//  MWCrewMemberTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCrewMemberTableViewCell: UITableViewCell {
    
    private var crewMember: MWMovieCrewMember?
    
    private let offsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
    
    private lazy var arrowImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.image = UIImage(named: "nextArrow")
        return view
    }()
    
    private lazy var memberNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.memberNameLabel)
        self.contentView.addSubview(self.arrowImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        self.memberNameLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.offsets)
        }
        
        self.arrowImageView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview().inset(self.offsets)
            make.left.greaterThanOrEqualTo(self.memberNameLabel.snp.right)
        }
        
        super.updateConstraints()
    }
    
    func set(crewMember: MWMovieCrewMember?) {
        self.crewMember = crewMember
        self.memberNameLabel.text = crewMember?.name
        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }
}
