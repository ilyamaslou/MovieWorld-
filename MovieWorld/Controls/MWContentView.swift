//
//  MWContentView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import SnapKit

class MWContentView: UIView {
    
    private let insets = UIEdgeInsets(top: 76, left: 16, bottom: 8, right: 16)
    private let contentInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    private let imageSize = CGSize(width: 80, height: 120)
    private let film = MWFilm()
    
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
        label.text = film.filmName
        return label
    }()
    
    private lazy var releaseYearAndCountryLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        var releaseYearAndCountry = "\(film.releaseYear), \(film.filmCountry)"
        label.text = releaseYearAndCountry
        return label
    }()
    
    private lazy var genresLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .gray
        
        var genres = ""
        for genre in film.filmGenres {
            genres += "\(genre), "
        }
        let range = genres.index(genres.endIndex, offsetBy: -2)..<genres.endIndex
        genres.removeSubrange(range)
        
        label.text = genres
        return label
    }()
    
    private lazy var ratingsLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        var ratings = "IMBD \(film.imbdRating), KP \(film.kpRating)"
        label.text = ratings
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(filmImageView)
        addSubview(containerView)
        containerView.addSubview(filmNameLabel)
        containerView.addSubview(releaseYearAndCountryLable)
        containerView.addSubview(genresLable)
        containerView.addSubview(ratingsLable)
        
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    override func updateConstraints() {
    //
    //        self.filmImageView.snp.updateConstraints { (make) in
    //            make.top.left.equalToSuperview().inset(insets)
    //            make.size.equalTo(imageSize)
    //        }
    //
    //        self.containerView.snp.updateConstraints { (make) in
    //            make.left.equalTo(filmImageView.snp.right).inset(-16)
    //            make.top.equalToSuperview().inset(insets)
    //            make.bottom.equalTo(filmImageView.snp.bottom)
    //
    //        }
    //
    //        self.filmNameLabel.snp.updateConstraints { (make) in
    //            make.top.left.equalToSuperview().inset(contentInsets)
    //        }
    //
    //        self.releaseYearAndCountryLable.snp.updateConstraints { (make) in
    //            make.top.equalTo(filmNameLabel.snp.bottom).offset(8)
    //            make.left.equalTo(filmNameLabel.snp.left)
    //
    //        }
    //
    //        self.genresLable.snp.updateConstraints { (make) in
    //            make.top.equalTo(releaseYearAndCountryLable.snp.bottom).offset(6)
    //            make.left.equalTo(releaseYearAndCountryLable.snp.left)
    //        }
    //
    //        self.ratingsLable.snp.updateConstraints { (make) in
    //            make.left.equalTo(genresLable.snp.left)
    //            make.bottom.equalToSuperview()
    //        }
    //
    //        super.updateConstraints()
    //    }
    
    private func makeConstraints() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.filmImageView.translatesAutoresizingMaskIntoConstraints = false
        self.filmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.releaseYearAndCountryLable.translatesAutoresizingMaskIntoConstraints = false
        self.genresLable.translatesAutoresizingMaskIntoConstraints = false
        self.ratingsLable.translatesAutoresizingMaskIntoConstraints = false
        
        let topImageViewConstraint = NSLayoutConstraint(item: filmImageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: insets.top)
        let leftImageViewConstraint = NSLayoutConstraint(item: filmImageView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: insets.left)
        let imageWidth = NSLayoutConstraint(item: filmImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: imageSize.width)
        let imageHeight = NSLayoutConstraint(item: filmImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageSize.height)
        
        let topContainerConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: insets.top)
        let leftContainerConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: filmImageView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: insets.left)
        let bottomContainerConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: filmImageView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        
        let topFilmNameLabelConstraint = NSLayoutConstraint(item: filmNameLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: contentInsets.top)
        let leftFilmNameLabelConstraint = NSLayoutConstraint(item: filmNameLabel, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        
        let topReleaseYearAndCountryLabelConstraint = NSLayoutConstraint(item: releaseYearAndCountryLable, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: filmNameLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 8)
        let leftReleaseYearAndCountryLabelConstraintConstraint = NSLayoutConstraint(item: releaseYearAndCountryLable, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: filmNameLabel, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        
        let topGenresLabelConstraint = NSLayoutConstraint(item: genresLable, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: releaseYearAndCountryLable, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 6)
        let leftGenresLabelConstraint = NSLayoutConstraint(item: genresLable, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: releaseYearAndCountryLable, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        
        let bottomRatingLabelConstraint = NSLayoutConstraint(item: ratingsLable, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -16)
        let leftRatingLabelConstraint = NSLayoutConstraint(item: ratingsLable, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: genresLable, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        
        self.containerView.addConstraints([topFilmNameLabelConstraint,
                                           leftFilmNameLabelConstraint,
                                           topReleaseYearAndCountryLabelConstraint,
                                           leftReleaseYearAndCountryLabelConstraintConstraint,
                                           topGenresLabelConstraint,
                                           leftGenresLabelConstraint,
                                           bottomRatingLabelConstraint,
                                           leftRatingLabelConstraint])
        
        self.addConstraints([topImageViewConstraint,
                             leftImageViewConstraint,
                             topContainerConstraint,
                             leftContainerConstraint,
                             bottomContainerConstraint,
                             imageWidth,
                             imageHeight])
    }
    
}
