//
//  MWMovieGalleryCollectionViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/30/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWMovieGalleryCollectionViewCell: UICollectionViewCell {
    
    private lazy var movieImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        self.contentView.addSubview(movieImageView)
        
        self.movieImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func set(image: Data) {
        self.movieImageView.image = UIImage(data: image)
    }
}
