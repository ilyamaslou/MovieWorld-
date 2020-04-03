//
//  MWCastMemberTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastMemberTableViewCell: UITableViewCell {
    
    private var castMember: MWMovieCastMember?
    
    private let offsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    
    private lazy var memberImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        setNeedsUpdateConstraints()
        return view
    }()
    
    private lazy var memberNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17,  weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var memberRoleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var memberBirthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.memberImageView)
        self.contentView.addSubview(self.memberNameLabel)
        self.contentView.addSubview(self.memberRoleLabel)
        self.contentView.addSubview(self.memberBirthLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        self.memberImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.offsets)
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
        
        self.memberNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(self.offsets)
            make.right.equalToSuperview()
            make.left.equalTo(self.memberImageView.snp.right).offset(self.offsets.left)
        }
        
        self.memberRoleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.memberNameLabel.snp.bottom).offset(3)
            make.right.equalToSuperview()
            make.left.equalTo(self.memberImageView.snp.right).offset(self.offsets.left)
        }
        
        self.memberBirthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.memberRoleLabel.snp.bottom).offset(1)
            make.right.equalToSuperview()
            make.left.equalTo(self.memberImageView.snp.right).offset(self.offsets.left)
            make.bottom.equalToSuperview().inset(4)
        }
        
        super.updateConstraints()
    }
    
    func set(castMember: MWMovieCastMember?) {

        self.castMember = castMember
        self.memberNameLabel.text = castMember?.name
        self.memberRoleLabel.text = castMember?.character
        self.memberBirthLabel.text = "Birthday?"
        
        if let image = castMember?.image {
            self.memberImageView.image = UIImage(data: image)
        } else {
            self.memberImageView.image = UIImage(named: "imageNotFound")
        }
        
        layoutIfNeeded()
    }
}
