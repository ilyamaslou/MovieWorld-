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
    
    private var page: Int = 1
    private var totalPages: Int = 0
    private var totalItems: Int = 0
    private var filteredPage: Int = 1
    private var filteredTotalPages: Int = 0
    private var filteredTotalItems: Int = 0
    private var isRequestBusy: Bool = false
    private var searchTitle: String = ""
    private var searchFilters: (genres: Set<String>, countries: [String?], year: String, ratingRange: (Float, Float)?)?
    
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
    
    private lazy var filterBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "filterIcon"),
                                                                        style: .plain,
                                                                        target: self,
                                                                        action: #selector(filterButtonDidTapped))
    
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
    
    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .whiteLarge
        view.color = UIColor(named: "accentColor")
        return view
    }()
    
    override func initController() {
        super.initController()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movieImageUpdated),
                                               name: .movieImageUpdated, object: nil)
        
        self.presettingSearchControllerNavBar()
        self.setUpView()
        self.loadMovies()
    }
    
    private func setUpView() {
        self.contentView.addSubview(self.tableView)
        self.contentView.addSubview(self.loadingSpinner)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.loadingSpinner.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    private func presettingSearchControllerNavBar() {
        self.title = "Search"
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = self.searchController
        self.navigationItem.setRightBarButton(self.filterBarButton, animated: true)
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc private func movieImageUpdated() {
        self.tableView.reloadData()
    }
    
    @objc private func filterButtonDidTapped() {
        let controller = MWFilterViewController(filters: self.searchFilters)
        MWI.s.pushVC(controller)
        
        controller.choosenFilters = { [weak self] (genres, countries, year, ratingRange) in
            self?.searchFilters = (genres, countries, year, ratingRange)
        }
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
    private func load(urlPath: String, querry: [String: String], completion: @escaping (MWMoviesResponse) -> Void) {
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: querry,
                         succesHandler: { (movies: MWMoviesResponse)  in
                            completion(movies)
        },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
    }
    
    private func loadMovies() {
        self.loadingSpinner.startAnimating()
        let urlPath = URLPaths.trandingDayMovies
        var query = MWNet.sh.parameters
        query["page"] = "\(self.page)"
        self.load(urlPath: urlPath, querry: query) { [weak self] (movies) in
            guard let self = self else { return }
            self.page += 1
            self.isRequestBusy = false
            self.totalItems = movies.totalResults
            self.totalPages = movies.totalPages
            self.movies += movies.results
            self.setGenreAndImage(to: self.movies)
            self.loadingSpinner.stopAnimating()
        }
    }
    
    private func searchMovies() {
        self.loadingSpinner.startAnimating()
        let urlPath = URLPaths.searchMovies
        var query = MWNet.sh.parameters
        query["query"] = self.searchTitle
        query["page"] = "\(self.filteredPage)"
        self.load(urlPath: urlPath, querry: query) { [weak self] (movies) in
            guard let self = self else { return }
            self.filteredPage += 1
            self.isRequestBusy = false
            self.filteredTotalItems = movies.totalResults
            self.filteredTotalPages = movies.totalPages
            self.filteredMovies += movies.results
            self.setGenreAndImage(to: self.filteredMovies)
            self.loadingSpinner.stopAnimating()
        }
    }
    
    private func loadNextPage() {
        guard !self.isRequestBusy,
            self.movies.count != self.totalItems else { return }
        self.isRequestBusy = true
        self.loadMovies()
    }
    
    private func loadNextSearchPage() {
        guard !self.isRequestBusy,
            self.filteredMovies.count != self.filteredTotalItems else { return }
        self.isRequestBusy = true
        self.searchMovies()
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
            self.searchTitle = text
            self.searchMovies()
            self.filteredMovies = self.movies.filter { ($0.title?.contains(text) ?? false) }
        }
        
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.setFilteredValuesToDefault()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.setFilteredValuesToDefault()
        }
    }
    
    private func setFilteredValuesToDefault() {
        self.filteredPage = 1
        self.filteredTotalPages = 0
        self.filteredTotalItems = 0
    }
}

extension MWSearchViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rowUnit = self.filteredMovies[indexPath.row]
        guard filteredMovies.count > 5 else { return }
        let unit = self.filteredMovies[self.filteredMovies.count - 5]
        if self.filteredMovies == self.movies,
            self.totalItems > self.filteredMovies.count,
            rowUnit.id == unit.id {
            self.loadNextPage()
        } else if self.filteredMovies != self.movies,
            !self.filteredMovies.isEmpty,
            self.filteredTotalItems > self.filteredMovies.count,
            rowUnit.id == unit.id {
            self.loadNextSearchPage()
        }
    }
}
