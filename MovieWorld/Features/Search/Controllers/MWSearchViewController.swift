//
//  MWSearchViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/21/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
import UIKit
import SnapKit

class MWSearchViewController: MWViewController {
    
    private var movies: [MWMovie] = [] {
        didSet {
            self.filteredMovies = self.movies
            self.tableView.reloadData()
        }
    }
    
    private var filteredMovies: [MWMovie] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(MWSingleMovieInCategoryCell.self,
                           forCellReuseIdentifier: Constants.singleCategoryTableViewCellId)
        return tableView
    }()
    
    private lazy var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func initController() {
        super.initController()
        self.title = "Search"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movieImageUpdated),
                                               name: .movieImageUpdated, object: nil)
        
        
        self.presettingSearchController()
        self.setUpView()
        self.loadMovies()
    }
    
    private func setUpView() {
        contentView.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func presettingSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = self.searchController
        self.searchController.searchBar.delegate = self
    }
    
    @objc func movieImageUpdated() {
        self.tableView.reloadData()
    }
}

extension MWSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.singleCategoryTableViewCellId) as? MWSingleMovieInCategoryCell
            else { fatalError("The registered type for the cell does not match the casting") }
        
        cell.set(movie: self.filteredMovies[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MWI.s.pushVC(MWSingelMovieViewController(movie: self.filteredMovies[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0  else { return 0 }
        return 16
    }
}

extension MWSearchViewController {
    private func load(urlPath: String, querry: [String: String], completion: @escaping ([MWMovie]) -> Void) {
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: querry,
                         succesHandler: { (movies: MWMoviesResponse)  in
                            completion(movies.results)
        },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
    }
    
    private func loadMovies() {
        let urlPath = URLPaths.trandingDayMovies
        let query = MWNet.sh.parameters
        self.load(urlPath: urlPath, querry: query) { (movies) in
            self.movies = movies
            self.setGenreAndImage(to: self.movies)
        }
    }
    
    private func searchMovies(with title: String) {
        let urlPath = URLPaths.searchMovies
        var query = MWNet.sh.parameters
        query["query"] = title
        self.load(urlPath: urlPath, querry: query) { (movies) in
            self.filteredMovies = movies
            self.setGenreAndImage(to: self.filteredMovies)
        }
    }
    
    private func setGenreAndImage(to movies: [MWMovie]) {
        for movie in movies {
            movie.setFilmGenres(genres: MWSys.sh.genres)
            MWImageLoadingHelper.sh.loadMovieImage(for: movie)
        }
    }
}

extension MWSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty {
            self.filteredMovies = self.movies
        } else {
            self.searchMovies(with: text)
            self.filteredMovies = self.movies.filter { ($0.title?.contains(text) ?? false) }
        }
        
        self.tableView.reloadData()
    }
}
