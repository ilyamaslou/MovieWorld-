//
//  ViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class MWMainTabViewController: MWViewController {

    //MARK: - private variables

    private var moviesByCategories: [MWMainCategories: [MWMovie]] = [:] {
        didSet {
            self.tableView.reloadData()
        }
    }

    private var moviesResultsInfoByCategories: [MWMainCategories: (totalResults: Int, totalPages: Int)] = [:]
    private var group = DispatchGroup()

    //MARK:- gui variables

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "accentColor")
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.refreshControl = self.refreshControl
        tableView.register(MWMainTableViewCell.self, forCellReuseIdentifier: MWMainTableViewCell.reuseIdentifier)
        return tableView
    }()

    //MARK: - initialization

    override func initController() {
        super.initController()
        self.title = "Season".local()
        self.makeConstraints()

        self.loadMovies()
        self.group.notify(queue: .main, execute: self.tableView.reloadData)
    }

    //MARK: - constraints

    private func makeConstraints() {
        contentView.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }

    //MARK: - request

    private func loadMovies() {
        var urlPath = ""

        for category in MWMainCategories.allCases {
            urlPath = category.getCategoryUrlPath()

            self.group.enter()
            MWNet.sh.request(urlPath: urlPath ,
                             querryParameters: MWNet.sh.parameters,
                             succesHandler: { [weak self] (movies: MWMoviesResponse)  in
                                guard let self = self else { return }

                                self.moviesResultsInfoByCategories[category] = (movies.totalResults,
                                                                                movies.totalPages)
                                self.setGenres(to: movies.results)
                                self.setImages(to: movies.results, in: category.rawValue)
                                self.moviesByCategories[category] = movies.results
                                self.save(mwCategory: category, movies: movies.results)
                                self.refreshControl.endRefreshing()
                                self.group.leave()
                },
                             errorHandler: { [weak self] (error) in
                                guard let self = self else { return }

                                let message = error.getErrorDesription()
                                self.errorAlert(message: message)

                                let movies = self.fetchMoviesByCategory(by: category)
                                self.setMoviesToCategory(category: category, movies: movies)
                                self.refreshControl.endRefreshing()
                                self.group.leave()
            })
        }
    }

    //MARK: - setters

    private func setGenres(to movies: [MWMovie]) {
        for movie in movies {
            movie.setFilmGenres(genres: MWSys.sh.genres)
        }
    }

    private func setImages(to movies: [MWMovie], in category: String) {
        for movie in movies {
            MWImageLoadingHelper.sh.loadMovieImage(for: movie, in: category)
        }
    }

    //MARK: - update action

    @objc private func pullToRefresh() {
        self.loadMovies()
        self.group.notify(queue: .main, execute: self.tableView.reloadData)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension MWMainTabViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.moviesByCategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMainTableViewCell.reuseIdentifier) as? MWMainTableViewCell
            else { return UITableViewCell() }

        let category = Array(self.moviesByCategories.keys)[indexPath.section]
        if let movies = self.moviesByCategories[category] {
            cell.movies = movies
            cell.set(categoryName: category, totalResults: self.moviesResultsInfoByCategories[category])
        }

        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}

//MARK: CoreData
extension MWMainTabViewController {
    private func saveAndReload(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }

    private func fetchMoviesByCategory(by category: MWMainCategories) -> [Movie] {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY category.movieCategory = %@", category.rawValue)

        var result: [Movie] = []
        do {
            result = try managedContext.fetch(fetch)
        } catch {
            print(error.localizedDescription)
        }
        return result
    }

    private func save(mwCategory: MWMainCategories, movies: [MWMovie]) {
        let result = self.fetchMoviesByCategory(by: mwCategory)
        let managedContext = CoreDataManager.s.persistentContainer.viewContext

        if result.isEmpty {
            let category = MovieCategory(context: managedContext)
            category.movieCategory = mwCategory.rawValue

            for movie in movies {
                let newMovie = Movie(context: managedContext)
                newMovie.id = Int64(movie.id ?? 0)
                newMovie.posterPath = movie.posterPath
                newMovie.genreIds = movie.genreIds
                newMovie.title = movie.title
                newMovie.originalLanguage = movie.originalLanguage
                newMovie.releaseDate = movie.releaseDate
                if let movieRating = movie.voteAvarage {
                    newMovie.voteAvarage = movieRating
                }
                category.addToMovies(newMovie)
            }
        } else {
            for (id, movie) in movies.enumerated() {
                let movieToUpdate = result[id]
                movieToUpdate.id = Int64(movie.id ?? 0)
                movieToUpdate.posterPath = movie.posterPath
                movieToUpdate.genreIds = movie.genreIds
                movieToUpdate.title = movie.title
                movieToUpdate.originalLanguage = movie.originalLanguage
                movieToUpdate.releaseDate = movie.releaseDate
                guard let movieRating = movie.voteAvarage else { return }
                movieToUpdate.voteAvarage = movieRating
            }
        }

        self.saveAndReload(context: managedContext)
    }

    private func setMoviesToCategory(category: MWMainCategories, movies: [Movie]) {
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
        self.moviesByCategories[category] = mwMovies
        self.tableView.reloadData()
    }
}
