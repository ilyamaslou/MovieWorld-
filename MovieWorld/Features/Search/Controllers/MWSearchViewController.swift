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
        
        self.presettingSearchController()
        self.setUpView()
        self.loadTrandingMovies()
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
    private func loadTrandingMovies() {
        let urlPath = URLPaths.trandingDayMovies
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (movies: MWMoviesResponse)  in
                            guard let self = self else { return }
                            
                            self.movies = movies.results
                            self.setGenres()
                            self.setImages()
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
    }
    
    private func setGenres() {
        for movie in self.movies {
            movie.setFilmGenres(genres: MWSys.sh.genres)
        }
    }
    
    private func setImages() {
        for movie in self.movies {
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
            self.filteredMovies = self.movies.filter { ($0.title?.contains(text) ?? false) }
        }
        
        self.tableView.reloadData()
    }
}
