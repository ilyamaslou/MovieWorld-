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

    //MARK: - static variable

    static var reuseIdentifier: String = "MWSingleMovieInCategoryCell"

    //MARK: - private variable

    private var movie = MWMovie()

    //MARK:- gui variable

    private lazy var movieView = MWSingleMovieView()

    // MARK: - constraints

    override func updateConstraints() {
        self.contentView.addSubview(self.movieView)

        self.movieView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }

    //MARK:- setter

    func set(movie: MWMovie) {
        self.movieView.setView(movie: movie)
        self.setNeedsUpdateConstraints()
        self.layoutIfNeeded()
    }
}
