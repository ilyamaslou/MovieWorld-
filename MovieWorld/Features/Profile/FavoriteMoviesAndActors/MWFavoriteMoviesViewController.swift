//
//  MWFavoriteMoviesAndActorsViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/13/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import CoreData

class MWFavoriteMoviesViewController: MWViewController {

    //MARK: - private variables

    private var movies: [MWMovie] = []

    //MARK:- gui variables

    private lazy var moviesByGenresController = MWSingleCategoryViewController(movies: self.movies)

    private lazy var emptyListLabel = MWEmptyListLabel()

    //MARK: - initialization

    override func initController() {
        super.initController()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateTableView),
                                               name: .movieIsFavoriteChanged, object: nil)
        self.add(self.moviesByGenresController)
        self.contentView.addSubview(emptyListLabel)
        self.makeConstraints()
        self.updateTableView()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.moviesByGenresController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.emptyListLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    //MARK: - action if favorites list is empty

    private func setUpVisibleOfEmptyListLabel(listIsEmpty: Bool) {
        self.emptyListLabel.isHidden = !listIsEmpty
    }

    //MARK: - Update TableView action

    @objc private func updateTableView() {
        self.moviesByGenresController.setTableViewMovies(movies: self.getFavoriteMovies())
    }
}

//MARK: - CoreData FavoritesMovies

extension MWFavoriteMoviesViewController {
    @discardableResult private func fetchFavoriteMovies() -> [Movie] {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY favorite != nil")

        var result: [Movie] = []
        do {
            result = try managedContext.fetch(fetch)
        } catch {
            print(error.localizedDescription)
        }

        self.setUpVisibleOfEmptyListLabel(listIsEmpty: result.isEmpty)
        return result
    }

    private func getFavoriteMovies() -> [MWMovie] {
        let movies = self.fetchFavoriteMovies()
        var mwMovies: [MWMovie] = []
        for movie in movies {
            let newMovie = MWMovie()
            newMovie.id = Int(movie.id)
            newMovie.posterPath = movie.posterPath
            newMovie.genreIds = movie.genreIds
            newMovie.title = movie.title
            newMovie.originalLanguage = movie.originalLanguage
            newMovie.releaseDate = movie.releaseDate
            newMovie.voteAvarage = movie.voteAvarage

            if let imageData = movie.movieImage {
                newMovie.image = imageData
            }

            newMovie.setMovieGenres(genres: MWSys.sh.genres)

            mwMovies.append(newMovie)
        }
        return mwMovies
    }
}
