//
//  MWSingleMovieView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/27/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWSingleMovieView: UIView {

    //MARK:- insets and size variables

    private let edgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 8, right: -16)
    private let contentInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    private let imageSize = CGSize(width: 80, height: 120)

    //MARK: - private variables

    private var movie = MWMovie()

    //MARK:- gui variables

    private lazy var filmImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()

    private lazy var filmNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    private lazy var releaseYearAndCountryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    private lazy var ratingsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    private lazy var separationLabel: UILabel = {
        let label = UILabel()
        label.layer.backgroundColor = UIColor.lightGray.cgColor
        label.layer.opacity = 0.2
        return label
    }()

    //MARK: - initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    override func updateConstraints() {
        self.filmImageView.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.edgeInsets)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(self.imageSize)
        }

        self.filmNameLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(self.edgeInsets.top)
            make.left.equalTo(filmImageView.snp.right).offset(self.edgeInsets.left)
            make.right.equalToSuperview()
        }

        self.releaseYearAndCountryLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.filmNameLabel.snp.bottom).offset(3)
            make.left.equalTo(filmImageView.snp.right).offset(self.edgeInsets.left)
            make.right.equalToSuperview()
        }

        self.genresLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.releaseYearAndCountryLabel.snp.bottom).offset(1)
            make.left.equalTo(filmImageView.snp.right).offset(self.edgeInsets.left)
            make.right.equalToSuperview()
        }

        self.ratingsLabel.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(genresLabel.snp.bottom).offset(8)
            make.left.equalTo(filmImageView.snp.right).offset(self.edgeInsets.left)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(self.edgeInsets.bottom)
        }

        self.separationLabel.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(3)
        }

        super.updateConstraints()
    }

    private func addSubviews() {
        self.addSubview(self.filmImageView)
        self.addSubview(self.filmNameLabel)
        self.addSubview(self.releaseYearAndCountryLabel)
        self.addSubview(self.genresLabel)
        self.addSubview(self.ratingsLabel)
        self.addSubview(self.separationLabel)
    }

    //MARK:- setters

    func setView(movie: MWMovie) {
        self.filmNameLabel.text = movie.title

        if let imageData = movie.image {
            self.filmImageView.image = UIImage(data: imageData)
        } else {
            self.filmImageView.image = UIImage(named: "imageNotFound")
        }

        let releasedYear = movie.getMovieReleaseYear().isEmpty ? "" : "\(movie.getMovieReleaseYear()),"
        self.releaseYearAndCountryLabel.text = "\(releasedYear) \(movie.originalLanguage ?? "")"
        self.genresLabel.text = self.setUpGenres(movieGenres: movie.movieGenres)

        if let movieRating = movie.voteAvarage, movieRating != 0 {
            self.ratingsLabel.text = "Rating: %.1f".local(args: movieRating)
        } else {
            self.ratingsLabel.text = "Not rated".local()
        }

        self.setNeedsUpdateConstraints()
    }

    private func setUpGenres(movieGenres: [String]?) -> String {
        guard let movieGenres = movieGenres else { return "" }

        var genres = ""
        for genre in movieGenres {
            genres += "\(genre), "
        }

        if !genres.isEmpty {
            genres.removeLast(2)
        }

        return genres
    }
}
