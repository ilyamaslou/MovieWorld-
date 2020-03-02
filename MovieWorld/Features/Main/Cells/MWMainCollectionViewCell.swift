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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpCell()
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Film Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17,  weight: .bold)
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Year + Country"
        label.font = .systemFont(ofSize: 13,  weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var filmImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bridgesFilmImage")
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setUpCell() {
        backgroundColor = .white
        
        contentView.addSubview(self.nameLabel)
        contentView.addSubview(self.infoLabel)
        contentView.addSubview(self.filmImageView)

        self.filmImageView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.nameLabel.snp.updateConstraints { (make) in
            make.top.equalTo(filmImageView.snp.bottom).inset(-12)
            make.left.equalToSuperview()
            
        }
        
        self.infoLabel.snp.updateConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.bottom.equalToSuperview()
        }
        
    }
    
    func set(film: MWMovie){
        self.nameLabel.text = film.title
        
        // MARK:  FIX THIS TEMP Solution
        let genre = "\(film.filmGenres?.first ?? "")" 
        var releaseDate = film.release_date ?? ""
        if genre != "" && releaseDate != ""{
            releaseDate.append(",")
        }
        
        self.infoLabel.text = "\(releaseDate) \(genre)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
