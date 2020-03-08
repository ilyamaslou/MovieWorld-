//
//  MWContentView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import SnapKit

class MWFilmModelView: UIView {
    
    private let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    private let contentInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    private let imageSize = CGSize(width: 80, height: 120)
    private let film = MWMovie()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var filmImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "GreenBookImage")
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var filmNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17,  weight: .semibold)
        label.text = self.film.title
        return label
    }()
    
    private lazy var releaseYearAndCountryLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        var releaseYearAndCountry = "\(self.film.releaseDate ?? ""), \(self.film.originalLanguage ?? "")"
        label.text = releaseYearAndCountry
        return label
    }()
    
    private lazy var genresLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .gray
        label.text = self.setUpGenres()
        return label
    }()
    
    private lazy var ratingsLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        var ratings = "IMBD , KP "
        label.text = ratings
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(self.filmImageView)
        addSubview(self.containerView)
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
            make.top.right.equalToSuperview().inset(self.insets)
            make.bottom.equalTo(self.filmImageView.snp.bottom)
            
        }
        
        self.filmNameLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(self.contentInsets)
        }
        
        self.releaseYearAndCountryLable.snp.updateConstraints { (make) in
            make.top.equalTo(self.filmNameLabel.snp.bottom).offset(8)
            make.left.equalTo(self.filmNameLabel.snp.left)
            make.right.equalToSuperview()
            
        }
        
        self.genresLable.snp.updateConstraints { (make) in
            make.top.equalTo(self.releaseYearAndCountryLable.snp.bottom).offset(6)
            make.left.equalTo(self.releaseYearAndCountryLable.snp.left)
            make.right.equalToSuperview()
        }
        
        self.ratingsLable.snp.updateConstraints { (make) in
            make.left.equalTo(self.genresLable.snp.left)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    private func setUpGenres() -> String {
        var genres = ""
        
        guard let genreIds = self.film.genreIds else { return "" }
        for genre in genreIds {
            genres += "\(genre), "
        }
        
        let range = genres.index(genres.endIndex, offsetBy: -2)..<genres.endIndex
        genres.removeSubrange(range)
        
        return genres
    }
}
