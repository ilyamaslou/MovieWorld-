//
//  MWCastMemberCollectionViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/25/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastMemberCollectionViewCell: UICollectionViewCell {

    //MARK: - static variable

    static var reuseIdentifier: String = "MWCastMemberCollectionViewCell"

    //MARK: - size variable

    private var imageNotFoundSize = CGSize(width: 130, height: 185)

    //MARK: - private variables

    private var memberOfCast: MWMovieCastMember?

    //MARK:- gui variables

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var movieImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.infoLabel)
        self.contentView.addSubview(self.movieImageView)

        self.movieImageView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualTo(self.nameLabel.snp.top).offset(-12)
        }

        self.nameLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.movieImageView.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalTo(self.movieImageView.snp.right)
        }

        self.infoLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(self.movieImageView.snp.right)
        }
    }

    //MARK:- setters

    func set(actor: MWMovieCastMember) {
        self.memberOfCast = actor
        self.nameLabel.text = actor.name
        self.infoLabel.text = actor.character
        self.movieImageView.image = self.setImageView()
        self.setNeedsUpdateConstraints()
    }

    private func setImageView() -> UIImage? {
        guard let imageData = memberOfCast?.image else { return UIImage(named: "imageNotFound")?
            .resizeImage(targetSize: self.imageNotFoundSize ) }
        return UIImage(data: imageData)
    }
}
