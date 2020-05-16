//
//  MWFavoriteMoviesAndActorsViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/13/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWFavoriteMoviesViewController: MWViewController {

    //MARK: - private variables

    private var movies: [MWMovie] = []

    //MARK:- gui variables

    private lazy var moviesByGenresController = MWSingleCategoryViewController(movies: self.movies)

    //MARK: - initialization

    override func initController() {
        super.initController()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateTableView),
                                               name: .movieIsFavoriteChanged, object: nil)
        self.setUpView()
        self.updateTableView()
    }

    // MARK: - constraints

    private func setUpView() {
        self.add(self.moviesByGenresController)
        self.moviesByGenresController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    //MARK: - Update TableView action

    @objc private func updateTableView() {
        self.moviesByGenresController.setTableViewMovies(movies: MWCDHelp.sh.fetchFavoriteMovies())
    }
}
