//
//  MWMainCollectionViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/26/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWMainCollectionViewCell: UICollectionViewCell {

    static var reuseIdentifier: String = "MWMainCollectionViewCell"

    private var movie = MWMovie()

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(movie: MWMovie) {
        self.movie = movie
        self.nameLabel.text = movie.title
        self.movieImageView.image = self.setImageView()
        self.infoLabel.text = self.setInfoLabelText()
        self.setNeedsUpdateConstraints()
    }

    private func makeConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.infoLabel)
        self.contentView.addSubview(self.movieImageView)

        self.movieImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }

        self.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.movieImageView.snp.bottom).inset(-12)
            make.left.equalToSuperview()
            make.right.equalTo(self.movieImageView.snp.right)
        }

        self.infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(self.movieImageView.snp.right)
        }
    }

    private func setInfoLabelText() -> String {
        var releaseYear = ""
        if let releaseDate = self.movie.releaseDate {
            let dividedDate = releaseDate.split(separator: "-")
            releaseYear = String(dividedDate.first ?? "")
            releaseYear = releaseYear.isEmpty ? "" : "\(releaseYear),"
        }

        let genre = "\(self.movie.movieGenres?.first ?? "")"

        return "\(releaseYear) \(genre)"
    }

    private func setImageView() -> UIImage? {
        self.layoutIfNeeded()
        guard let imageData = movie.image else { return UIImage(named: "imageNotFound") }
        return UIImage(data: imageData)
    }
}
