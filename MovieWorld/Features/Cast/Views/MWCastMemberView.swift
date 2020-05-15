//
//  MWCastMemberCellView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastMemberView: UIView {

    //MARK: insets and size variables

    private let edgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    private let imageSize = CGSize(width: 80, height: 120)

    //MARK: - private variables

    private var castMember: MWMovieCastMember?

    //MARK:- gui variables

    private lazy var memberImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()

    private lazy var memberNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private lazy var memberRoleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    private lazy var memberBirthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    private lazy var separationView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.opacity = 0.2
        return view
    }()

    //MARK: - initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- constraints

    override func updateConstraints() {
        self.memberImageView.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.edgeInsets)
            make.size.equalTo(self.imageSize)
        }

        self.memberNameLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(self.edgeInsets)
            make.left.equalTo(self.memberImageView.snp.right).offset(self.edgeInsets.left)
            make.right.equalToSuperview()
        }

        self.memberRoleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.memberNameLabel.snp.bottom).offset(3)
            make.left.equalTo(self.memberNameLabel.snp.left)
            make.right.equalToSuperview()
        }

        self.memberBirthLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.memberRoleLabel.snp.bottom).offset(1)
            make.left.equalTo(self.memberRoleLabel.snp.left)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(4)
        }

        self.separationView.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
        super.updateConstraints()
    }

    private func addSubviews() {
        self.addSubview(self.memberImageView)
        self.addSubview(self.memberNameLabel)
        self.addSubview(self.memberRoleLabel)
        self.addSubview(self.memberBirthLabel)
        self.addSubview(self.separationView)
    }

    //MARK:- setters

    func set(castMember: MWMovieCastMember?, birthday: String = "") {
        self.castMember = castMember
        self.memberNameLabel.text = castMember?.name
        self.memberRoleLabel.text = castMember?.character

        if let image = castMember?.image {
            self.memberImageView.image = UIImage(data: image)
        } else {
            self.memberImageView.image = UIImage(named: "imageNotFound")
        }

        self.setUpBirthday(birthday: birthday)

        self.setNeedsUpdateConstraints()
    }

    func setUpBirthday(birthday: String) {
        guard let age = birthday.toDate() else { return }
        let formattedBirthday = age.toString(format: "dd.MM.yyyy")

        self.memberBirthLabel.text = "%@ (%d years)".local(args: formattedBirthday, age.toAge)
    }
}
