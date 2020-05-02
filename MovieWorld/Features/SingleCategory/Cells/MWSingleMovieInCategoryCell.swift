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
    
    private var movie = MWMovie()
    
    private lazy var movieView = MWSingleMovieView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.movieView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        self.movieView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    func set(movie: MWMovie) {
        self.movieView.setView(movie: movie)
        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }
}
