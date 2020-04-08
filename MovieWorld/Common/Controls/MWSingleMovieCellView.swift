//
//  MWSingleMovieView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/27/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWSingleMovieCellView: UIView {
    
    private let offsets = UIEdgeInsets(top: 10, left: 16, bottom: 8, right: -16)
    private let contentInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    private var movie: MWMovie = MWMovie()
    
    private lazy var filmImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        setNeedsUpdateConstraints()
        return view
    }()
    
    private lazy var filmNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17,  weight: .semibold)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private lazy var releaseYearAndCountryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var ratingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
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
        
        self.addSubview(self.filmImageView)
        self.addSubview(self.filmNameLabel)
        self.addSubview(self.releaseYearAndCountryLabel)
        self.addSubview(self.genresLabel)
        self.addSubview(self.ratingsLabel)
    }
    
    override func updateConstraints() {
        
        self.filmImageView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(self.offsets.left)
            make.top.equalToSuperview().offset(self.offsets.top)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(80)
        }
        
        self.filmNameLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(self.offsets.top)
            make.left.equalTo(filmImageView.snp.right).offset(self.offsets.left)
            make.right.equalToSuperview()
        }
        
        self.releaseYearAndCountryLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.filmNameLabel.snp.bottom).offset(3)
            make.left.equalTo(filmImageView.snp.right).offset(self.offsets.left)
            make.right.equalToSuperview()
        }
        
        self.genresLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.releaseYearAndCountryLabel.snp.bottom).offset(1)
            make.left.equalTo(filmImageView.snp.right).offset(self.offsets.left)
            make.right.equalToSuperview()
        }
        
        self.ratingsLabel.snp.updateConstraints { (make) in
            make.top.equalTo(genresLabel.snp.bottom).offset(8)
            make.left.equalTo(filmImageView.snp.right).offset(self.offsets.left)
            make.bottom.equalToSuperview().inset(self.offsets.bottom)
            make.right.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    func setView(movie: MWMovie) {
        self.filmNameLabel.text = movie.title
        
        if let imageData = movie.image {
            self.filmImageView.image = UIImage(data: imageData)
        } else {
            self.filmImageView.image = UIImage(named: "imageNotFound")?
                .resizeImage(targetSize: CGSize(width: 80, height: 100))
        }
        
        var releaseYear = ""
        if let releaseDate = movie.releaseDate {
            let dividedDate = releaseDate.split(separator: "-")
            releaseYear = String(dividedDate.first ?? "")
        }
        
        self.releaseYearAndCountryLabel.text = "\(releaseYear), \(movie.originalLanguage ?? "")"
        self.genresLabel.text = self.setUpGenres(movieGenres: movie.movieGenres)
        
        guard let movieRating = movie.voteAvarage else { return }
        self.ratingsLabel.text = "Rating: \(movieRating)"
    }
    
    private func setUpGenres(movieGenres: [String]?) -> String {
        var genres = ""
        
        guard let movieGenres = movieGenres else { return "" }
        for genre in movieGenres {
            genres += "\(genre), "
        }
        
        if !genres.isEmpty {
            genres.removeLast(2)
        }
        
        return genres
    }
}
