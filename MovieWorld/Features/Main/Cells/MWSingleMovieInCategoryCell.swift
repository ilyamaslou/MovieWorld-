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
    
    private let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    private let contentInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    private let imageSize = CGSize(width: 80, height: 120)
    private var movie = MWMovie()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var filmImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var filmNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17,  weight: .semibold)
        return label
    }()
    
    private lazy var releaseYearAndCountryLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var genresLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    private lazy var ratingsLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        var ratings = "IMBD , KP "
        label.text = ratings
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.filmImageView)
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.filmNameLabel)
        self.containerView.addSubview(self.releaseYearAndCountryLable)
        self.containerView.addSubview(self.genresLable)
        self.containerView.addSubview(self.ratingsLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        self.filmImageView.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.insets)
            make.size.equalTo(self.imageSize)
        }
        
        self.containerView.snp.updateConstraints { (make) in
            make.left.equalTo(self.filmImageView.snp.right).inset(-16)
            make.top.equalToSuperview().inset(self.insets)
            make.bottom.equalTo(self.filmImageView.snp.bottom)
            
        }
        
        self.filmNameLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.contentInsets)
        }
        
        self.releaseYearAndCountryLable.snp.updateConstraints { (make) in
            make.top.equalTo(self.filmNameLabel.snp.bottom).offset(8)
            make.left.equalTo(self.filmNameLabel.snp.left)
        }
        
        self.genresLable.snp.updateConstraints { (make) in
            make.top.equalTo(self.releaseYearAndCountryLable.snp.bottom).offset(6)
            make.left.equalTo(self.releaseYearAndCountryLable.snp.left)
        }
        
        self.ratingsLable.snp.updateConstraints { (make) in
            make.left.equalTo(self.genresLable.snp.left)
            make.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    func set(movie: MWMovie) {
        self.filmImageView.image = movie.movieImage
        self.filmNameLabel.text = movie.title
        
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
