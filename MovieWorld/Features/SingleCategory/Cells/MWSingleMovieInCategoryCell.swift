//
//  MWContentView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWSingleMovieInCategoryCell: UITableViewCell {

    //MARK: - static variable

    static var reuseIdentifier: String = "MWSingleMovieInCategoryCell"

    //MARK: - private variable

    private var movie = MWMovie()

    //MARK:- gui variable

    private lazy var movieView = MWSingleMovieView()

    //MARK: - initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.movieView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    override func updateConstraints() {
        self.movieView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }

    //MARK:- setter

    func set(movie: MWMovie) {
        self.selectionStyle = .none
        self.movieView.setView(movie: movie)
        self.setNeedsUpdateConstraints()
    }
}
