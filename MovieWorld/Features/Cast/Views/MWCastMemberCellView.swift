//
//  MWCastMemberCellView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastMemberCellView: UIView {

    private let offsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

    private var castMember: MWMovieCastMember?

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
        label.font = .systemFont(ofSize: 17, weight: .bold)
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

    private lazy var sepparationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.opacity = 0.2
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
    }

    func setUpBirthday(birthday: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let stringFormatter = DateFormatter()
        stringFormatter.dateFormat = "dd.MM.yyyy"

        guard let age = dateFormatter.date(from: birthday) else { return }
        let formattedBirthday = stringFormatter.string(from: age)

        self.memberBirthLabel.text = "\(formattedBirthday) (\(age.toAge) years)"
    }

    private func setUpView() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.memberImageView)
        self.addSubview(self.memberNameLabel)
        self.addSubview(self.memberRoleLabel)
        self.addSubview(self.memberBirthLabel)
        self.addSubview(self.sepparationView)
    }

    override func updateConstraints() {
        self.memberImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.offsets)
            make.size.equalTo(CGSize(width: 70, height: 70))
        }

        self.memberNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(self.offsets)
            make.left.equalTo(self.memberImageView.snp.right).offset(self.offsets.left)
            make.right.equalToSuperview()
        }

        self.memberRoleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.memberNameLabel.snp.bottom).offset(3)
            make.left.equalTo(self.memberNameLabel.snp.left)
            make.right.equalToSuperview()
        }

        self.memberBirthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.memberRoleLabel.snp.bottom).offset(1)
            make.left.equalTo(self.memberRoleLabel.snp.left)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(4)
        }

        self.sepparationView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(3)
        }

        super.updateConstraints()
    }
}
