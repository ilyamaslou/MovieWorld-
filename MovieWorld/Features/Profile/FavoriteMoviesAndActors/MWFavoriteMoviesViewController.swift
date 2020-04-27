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
    
    private var movies: [MWMovie] = []
    
    private lazy var moviesByGenresController: MWSingleCategoryViewController = {
        return MWSingleCategoryViewController(movies: self.movies)
    }()
    
    private lazy var emptyListLabel: UILabel = {
        let label = UILabel()
        label.text = "The favorites movies list is empty"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.moviesByGenresController.setTableViewMovies(movies: self.getFavoriteMovies())
    }
    
    override func initController() {
        super.initController()
        self.setUpView()
    }
    
    private func setUpView() {
        guard let moviesByGenresView = self.moviesByGenresController.view else { return }
        
        self.contentView.addSubview(moviesByGenresView)
        self.contentView.addSubview(emptyListLabel)
        
        moviesByGenresView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.emptyListLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    private func setUpVisibleOfEmptyListLabel(listIsEmpty: Bool) {
        self.emptyListLabel.isHidden = listIsEmpty ? false : true
    }
}

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
            
            newMovie.setFilmGenres(genres: MWSys.sh.genres)
            
            mwMovies.append(newMovie)
        }
        return mwMovies
    }
}
