//
//  MWSearchViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/21/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
import UIKit

class MWSearchViewController: MWViewController {

    //MARK: - pagination variables

    private var page: Int = 1
    private var totalPages: Int = 0
    private var totalItems: Int = 0
    private var searchedPage: Int = 1
    private var searchedTotalPages: Int = 0
    private var searchedTotalItems: Int = 0

    private var isRequestBusy: Bool = false {
        didSet{
            self.isRequestBusy ? self.loadingSpinner.startAnimating() : self.loadingSpinner.stopAnimating()
        }
    }

    //MARK: - private variables

    private var searchTitle: String = ""
    private var movieFilters: MWFilters?

    private var movies: [MWMovie] = [] {
        didSet {
            self.searchMovies = self.movies
            self.tableView.reloadData()
        }
    }

    private var searchMovies: [MWMovie] = [] {
        didSet {
            self.filteredMovies = self.searchMovies
            self.setFilters()
            self.tableView.reloadData()
        }
    }

    private var filteredMovies: [MWMovie] = [] {
        didSet {
            self.loadAndSetImage()
            self.tableView.reloadData()
        }
    }

    //MARK:- gui variables

    private lazy var filterBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "filterIcon"),
                                                                        style: .plain,
                                                                        target: self,
                                                                        action: #selector(self.filterButtonDidTapped))

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(MWSingleMovieInCategoryCell.self,
                           forCellReuseIdentifier: MWSingleMovieInCategoryCell.reuseIdentifier)
        return tableView
    }()

    private lazy var searchController = UISearchController(searchResultsController: nil)

    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .whiteLarge
        view.color = UIColor(named: "accentColor")
        return view
    }()

    //MARK: - initialization

    override func initController() {
        super.initController()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.movieImageUpdated),
                                               name: .movieImageUpdated, object: nil)

        self.presettingSearchControllerNavBar()
        self.contentView.addSubview(self.tableView)
        self.contentView.addSubview(self.loadingSpinner)
        self.makeConstraints()

        self.loadMovies()
    }

    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.loadingSpinner.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    //MARK: - setting of navigation bar

    private func presettingSearchControllerNavBar() {
        self.title = "Search".local()
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = self.searchController
        self.navigationItem.setRightBarButton(self.filterBarButton, animated: true)
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    //MARK: - setter

    private func setFilters() {
        if let finalFilteredMovies = MWFilterHelper.sh.filter(for: self.filteredMovies, filters: self.movieFilters) {
            self.filteredMovies = finalFilteredMovies
        } else {
            self.filteredMovies = movies
        }
    }

    //MARK: - check and update actions

    private func checkFilteredMoviesOnFillnessAndLoad(loadMethod: () -> Void) {
        guard self.filteredMovies.count < 5 else { return }
        loadMethod()
    }

    @objc private func movieImageUpdated() {
        self.tableView.reloadData()
    }

    //MARK: - filter button tap action

    @objc private func filterButtonDidTapped() {
        let controller = MWFilterViewController(filters: self.movieFilters)
        MWI.s.pushVC(controller)

        controller.choosenFilters = { [weak self] (filters) in
            guard let self = self else { return }
            self.movieFilters = filters
            self.filteredMovies = self.movies
            self.setFilters()
            self.checkFilteredMoviesOnFillnessAndLoad(loadMethod: self.loadNextPage)
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MWSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWSingleMovieInCategoryCell.reuseIdentifier, for: indexPath)
        (cell as? MWSingleMovieInCategoryCell)?.set(movie: self.filteredMovies[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MWI.s.pushVC(MWSingleMovieViewController(movie: self.filteredMovies[indexPath.row]))
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section != 0) ? 16 : 0
    }
}

//MARK: - request functions

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
        let urlPath = URLPaths.trandingDayMovies
        var query = MWNet.sh.parameters
        query["page"] = "\(self.page)"
        self.load(urlPath: urlPath, querry: query) { [weak self] (movies) in
            guard let self = self else { return }
            self.page += 1
            self.isRequestBusy = false
            self.totalItems = movies.totalResults
            self.totalPages = movies.totalPages
            self.setGenres(to: movies.results)
            self.movies += movies.results
            self.checkFilteredMoviesOnFillnessAndLoad(loadMethod: self.loadNextPage)
        }
    }

    private func loadSearchedMovies() {
        let urlPath = URLPaths.searchMovies
        var query = MWNet.sh.parameters
        query["query"] = self.searchTitle
        query["page"] = "\(self.searchedPage)"
        self.load(urlPath: urlPath, querry: query) { [weak self] (movies) in
            guard let self = self else { return }
            self.searchedPage += 1
            self.isRequestBusy = false
            self.searchedTotalItems = movies.totalResults
            self.searchedTotalPages = movies.totalPages
            self.setGenres(to: movies.results)
            self.searchMovies += movies.results
            self.checkFilteredMoviesOnFillnessAndLoad(loadMethod: self.loadNextSearchPage)
        }
    }

    private func loadAndSetImage() {
        for movie in self.filteredMovies {
            MWImageLoadingHelper.sh.loadMovieImage(for: movie)
        }
    }

    //MARK: - Setter

    private func setGenres(to movies: [MWMovie]) {
        for movie in movies {
            movie.setMovieGenres(genres: MWSys.sh.genres)
        }
    }
}

//MARK: - UISearchResultsUpdating, UISearchBarDelegate

extension MWSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty {
            self.searchMovies = self.movies
        } else {
            self.searchTitle = text
            self.loadSearchedMovies()
            self.searchMovies = self.searchMovies.filter { ($0.title?.contains(text) ?? false) }
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
        self.searchedPage = 1
        self.searchedTotalPages = 0
        self.searchedTotalItems = 0
    }
}

//MARK: - pagination

extension MWSearchViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let text = searchController.searchBar.text, filteredMovies.count > 4 else { return }
        let rowUnit = self.filteredMovies[indexPath.row]
        let unit = self.filteredMovies[self.filteredMovies.count - 2]
        if text.isEmpty,
            self.totalItems > self.filteredMovies.count,
            rowUnit.id == unit.id {
            self.loadNextPage()
        } else if !text.isEmpty,
            self.searchedTotalItems > self.filteredMovies.count,
            rowUnit.id == unit.id {
            self.loadNextSearchPage()
        }
    }

    private func loadNextPage() {
        guard !self.isRequestBusy,
            self.filteredMovies.count != self.totalItems else { return }
        self.isRequestBusy = true
        self.loadMovies()
    }

    private func loadNextSearchPage() {
        guard !self.isRequestBusy,
            self.filteredMovies.count != self.searchedTotalItems else { return }
        self.isRequestBusy = true
        self.loadSearchedMovies()
    }
}
