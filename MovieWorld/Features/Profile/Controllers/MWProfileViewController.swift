//
//  ProfileViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/12/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import CoreData

class MWProfileViewController: MWViewController {
    
    private lazy var favoriteMovies: UIButton = {
        var button = UIButton()
        button.setTitle("Favorite movies", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(favoriteMoviesButtonDidPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func initController() {
        super.initController()
        
        let view = UIView()
        contentView.addSubview(view)
        view.addSubview(self.favoriteMovies)
        
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.favoriteMovies.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.title = "Profile"
    }
    
    @objc private func favoriteMoviesButtonDidPressed() {
        MWI.s.pushVC(MWSingleCategoryViewController(title: "Favorites",
                                                    movies: self.getFavoriteMovies()))
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
