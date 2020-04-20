//
//  MWCastMemberCellView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastMemberCellView: UIView {
    
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
    

    //FIXME: Question ? (if i set shadow) Why after scroll shadow dissapear
    private lazy var sepparationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.backgroundColor = UIColor.lightGray.cgColor
        label.layer.opacity = 0.2
//        label.layer.shadowRadius = 2
//        label.layer.shadowOpacity = 0.5
//        label.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
//        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.memberImageView)
        self.addSubview(self.memberNameLabel)
        self.addSubview(self.memberRoleLabel)
        self.addSubview(self.memberBirthLabel)
        self.addSubview(self.sepparationLabel)
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
            make.left.equalTo(self.memberNameLabel.snp.left)
        }
        
        self.memberBirthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.memberRoleLabel.snp.bottom).offset(1)
            make.right.equalToSuperview()
            make.left.equalTo(self.memberRoleLabel.snp.left)
            make.bottom.equalToSuperview().inset(4)
        }
        
        self.sepparationLabel.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
        
        super.updateConstraints()
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
}
