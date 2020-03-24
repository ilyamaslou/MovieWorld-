//
//  MWContentView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import SnapKit

class MWSingleMovieInCategoryCell: UITableViewCell {
    
    private let offsets = UIEdgeInsets(top: 10, left: 16, bottom: 8, right: -16)
    private let contentInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    private var movie = MWMovie()
    
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
        return label
    }()
    
    private lazy var releaseYearAndCountryLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var genresLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var ratingsLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        var ratings = "IMBD , KP "
        label.text = ratings
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.filmImageView)
        self.contentView.addSubview(self.filmNameLabel)
        self.contentView.addSubview(self.releaseYearAndCountryLable)
        self.contentView.addSubview(self.genresLable)
        self.contentView.addSubview(self.ratingsLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        self.releaseYearAndCountryLable.snp.updateConstraints { (make) in
            make.top.equalTo(self.filmNameLabel.snp.bottom).offset(3)
            make.left.equalTo(filmImageView.snp.right).offset(self.offsets.left)
            make.right.equalToSuperview()
        }
        
        self.genresLable.snp.updateConstraints { (make) in
            make.top.equalTo(self.releaseYearAndCountryLable.snp.bottom).offset(1)
            make.left.equalTo(filmImageView.snp.right).offset(self.offsets.left)
            make.right.equalToSuperview()
        }
        
        self.ratingsLable.snp.updateConstraints { (make) in
            make.top.equalTo(genresLable.snp.bottom).offset(8)
            make.left.equalTo(filmImageView.snp.right).offset(self.offsets.left)
            make.bottom.equalToSuperview().inset(self.offsets.bottom)
            make.right.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    func set(movie: MWMovie) {
        self.filmNameLabel.text = movie.title
        
        if let imageData = movie.image {
            self.filmImageView.image = UIImage(data: imageData)
        } else {
            self.filmImageView.image = UIImage(named: "imageNotFound")
        }
        
        var releaseYear = ""
        if let releaseDate = movie.releaseDate {
            let dividedDate = releaseDate.split(separator: "-")
            releaseYear = String(dividedDate.first ?? "")
        }
        
        self.releaseYearAndCountryLable.text = "\(releaseYear), \(movie.originalLanguage ?? "")"
        self.genresLable.text = self.setUpGenres(movieGenres: movie.movieGenres)
        setNeedsUpdateConstraints()
    }
    
    private func setUpGenres(movieGenres: [String]?) -> String {
        var genres = ""
        
        guard let movieGenres = movieGenres else { return "" }
        for genre in movieGenres {
            genres += "\(genre), "
        }
        
        let range = genres.index(genres.endIndex, offsetBy: -2)..<genres.endIndex
        genres.removeSubrange(range)
        
        return genres
    }
}
