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
    
    private lazy var filmImageView: UIImageView = {
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
    
    func set(film: MWMovie){
        self.nameLabel.text = film.title
        
        var releaseYear = ""
        if let releaseDate = film.releaseDate {
            let dividedDate = releaseDate.split(separator: "-")
            releaseYear = String(dividedDate.first ?? "")
        }
        
        let genre = "\(film.filmGenres?.first ?? "")" 
        if (genre.isEmpty  && film.releaseDate?.isEmpty ?? false) == false {
            releaseYear.append(",")
        }
        
        self.infoLabel.text = "\(releaseYear) \(genre)"
        self.filmImageView.image = film.filmImage
    }
    
    private func setUpCell() {
        backgroundColor = .white
        
        contentView.addSubview(self.nameLabel)
        contentView.addSubview(self.infoLabel)
        contentView.addSubview(self.filmImageView)
        
        self.filmImageView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(130)
        }
        
        self.nameLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.filmImageView.snp.bottom).inset(-12)
            make.left.equalToSuperview()
            make.right.equalTo(self.filmImageView.snp.right)
        }
        
        self.infoLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(self.filmImageView.snp.right)
        }
    }
}
