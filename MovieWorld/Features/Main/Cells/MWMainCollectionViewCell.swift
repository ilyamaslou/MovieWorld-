//
//  MWMainCollectionViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/26/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import SnapKit

class MWMainCollectionViewCell: UICollectionViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17,  weight: .bold)
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13,  weight: .regular)
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
        self.setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(movie: MWMovie){
        self.nameLabel.text = movie.title
        
        var releaseYear = ""
        if let releaseDate = movie.releaseDate {
            let dividedDate = releaseDate.split(separator: "-")
            releaseYear = String(dividedDate.first ?? "")
        }
        
        let genre = "\(movie.movieGenres?.first ?? "")"
        if (genre.isEmpty  && movie.releaseDate?.isEmpty ?? false) == false {
            releaseYear.append(",")
        }
        
        self.infoLabel.text = "\(releaseYear) \(genre)"
        
        self.setUpImageView(movie: movie)
    }
    
    private func setUpImageView(movie: MWMovie) {
        if movie.movieImage == nil {
            loadImage(for: movie)
            self.movieImageView.image = movie.movieImage
        } else {
            self.movieImageView.image = movie.movieImage
        }
    }
    
    private func setUpCell() {
        backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.infoLabel)
        self.contentView.addSubview(self.movieImageView)
        
        self.movieImageView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.nameLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.movieImageView.snp.bottom).inset(-12)
            make.left.equalToSuperview()
            make.right.equalTo(self.movieImageView.snp.right)
        }
        
        self.infoLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(self.movieImageView.snp.right)
        }
    }
    
    private func loadImage(for forMovie: MWMovie) {
        if let imagePath = forMovie.posterPath,
            let baseUrl = MWSys.sh.configuration?.images?.secureBaseUrl,
            let size = MWSys.sh.configuration?.images?.posterSizes?.first {
            MWNet.sh.imageRequest(baseUrl: baseUrl,
                                  size: size,
                                  filePath: imagePath,
                                  succesHandler: { [weak self] (image: UIImage)  in
                                    forMovie.movieImage = image
                                    self?.movieImageView.image = image
                }
            )
        }
    }
}
