//
//  MWFavoriteMoviesAndActorsViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/13/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import CoreData

class MWFavoriteMoviesAndActorsViewController: MWViewController {
    
    private var movies: [MWMovie] = []
    
    private lazy var moviesByGenresController: MWSingleCategoryViewController = {
        return MWSingleCategoryViewController(movies: self.movies)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.moviesByGenresController.updateTableAndCollectionView(movies: self.getFavoriteMovies())
    }
    
    init(title: String) {
        super.init()
        self.title = title
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        guard let moviesByGenresView = moviesByGenresController.view else { return }
        
        self.contentView.addSubview(moviesByGenresView)
        moviesByGenresView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
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
