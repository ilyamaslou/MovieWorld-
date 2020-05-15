//
//  MWSingleCategoryViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/18/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWSingleCategoryViewController: MWViewController {

    //MARK: - pagination variables

    private var page: Int = 2
    private var totalPages: Int = 0
    private var totalItems: Int = 0

    private var isRequestBusy: Bool = false {
        didSet{
            self.isRequestBusy
                ? self.loadingSpinner.startAnimating()
                : self.loadingSpinner.stopAnimating()
        }
    }

    private var shouldUseLoadingMethods = true

    //MARK: - size variable

    private let collectionViewHeight: Int = 70

    //MARK: - private variables

    private var category: MWMainCategories?

    private var movies: [MWMovie] = [] {
        didSet {
            self.filteredMovies = self.movies
            self.tableView.reloadData()
        }
    }

    private var filteredMovies: [MWMovie] = [] {
        didSet {
            self.checkFilteredMoviesEmptiness()
            self.tableView.reloadData()
        }
    }

    //MARK:- gui variables

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

    private lazy var collectionView = MWGenresCollectionViewController()

    private lazy var emptyListLabel: MWEmptyListLabel = {
        let label = MWEmptyListLabel()
        label.isHidden = true
        return label
    }()

    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .whiteLarge
        view.color = UIColor(named: "accentColor")
        return view
    }()

    //MARK: - initialization

    init(title: String = "Movies",
         movies: [MWMovie],
         category: MWMainCategories? = nil,
         totalResultsInfo: (totalResults: Int, totalPages: Int)? = (0, 0)) {
        super.init()
        self.title = title.local()
        self.category = category
        self.totalPages = totalResultsInfo?.totalPages ?? 0
        self.totalItems = totalResultsInfo?.totalResults ?? 0

        self.setTableViewMovies(movies: movies, useLoading: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initController() {
        super.initController()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateTableByGenres),
                                               name: .genresChanged, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateTableView),
                                               name: .movieImageUpdated, object: nil)
        self.addSubviews()
        self.makeConstraints()
    }

    // MARK: - constraints

    private func addSubviews() {
        self.add(self.collectionView)
        self.contentView.addSubview(self.tableView)
        self.contentView.addSubview(self.emptyListLabel)
        self.contentView.addSubview(self.loadingSpinner)
    }

    private func makeConstraints() {
        self.collectionView.view.snp.makeConstraints {(make) in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.collectionViewHeight)
        }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.view.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }

        self.emptyListLabel.snp.makeConstraints { (make) in
            make.center.equalTo(tableView.snp.center)
        }

        self.loadingSpinner.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    //MARK:- setter

    func setTableViewMovies(movies: [MWMovie], useLoading: Bool = false) {
        self.movies = movies
        self.shouldUseLoadingMethods = useLoading
    }

    //MARK: - check actions

    private func checkFilteredMoviesOnFillness() {
        guard self.filteredMovies.count < 5, self.shouldUseLoadingMethods else { return }
        self.loadUnits()
    }

    private func checkFilteredMoviesEmptiness() {
        self.emptyListLabel.isHidden = (self.page >= self.totalPages && self.filteredMovies.count == 0)
            ? false
            : true
    }

    //MARK:- update action

    @objc private func updateTableByGenres() {
        if self.collectionView.filteredGenres.isEmpty {
            self.filteredMovies = self.movies
            return
        }

        var tempFilteredMovies: [MWMovie] = []

        var filteredMovies: [MWMovie] = []
        self.collectionView.filteredGenres.forEach { (genre) in
            filteredMovies.append(contentsOf: self.movies.filter{ ($0.movieGenres?.contains(genre) ?? false) })
        }

        for movie in filteredMovies {
            guard !tempFilteredMovies.contains(movie) else { continue }
            tempFilteredMovies.append(movie)
        }

        self.filteredMovies = tempFilteredMovies
        self.checkFilteredMoviesOnFillness()
    }

    @objc private func updateTableView() {
        self.tableView.reloadData()
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate

extension MWSingleCategoryViewController: UITableViewDataSource, UITableViewDelegate {

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
        section != 0 ? 16 : 0
    }
}

//MARK: Pagination
extension MWSingleCategoryViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rowUnit = self.filteredMovies[indexPath.row]
        guard self.filteredMovies.count > 4 else { return }
        let unit = self.filteredMovies[self.filteredMovies.count - 2]
        if self.totalItems > self.movies.count,
            rowUnit.id == unit.id {
            self.loadUnits()
        }
    }

    private func loadUnits() {
        guard !self.isRequestBusy,
            self.movies.count != self.totalItems else { return }
        self.isRequestBusy = true

        self.loadMovies{ [weak self] (movies) in
            guard let self = self else { return }
            self.isRequestBusy = false
            self.page += 1
            self.movies += movies
            self.updateTableByGenres()
        }
    }

    private func loadMovies( completion: @escaping ([MWMovie]) -> Void) {
        guard let category = self.category,
            self.page <= self.totalPages else { return }
        let urlPath = category.getCategoryUrlPath()
        var query = MWNet.sh.parameters
        query["page"] = String(self.page)
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: query,
                         succesHandler: { [weak self] (movies: MWMoviesResponse)  in
                            guard let self = self else { return }
                            self.totalItems = movies.totalResults
                            self.totalPages = movies.totalPages
                            self.setGenres(to: movies.results)
                            self.loadAndSetImages(to: movies.results)
                            completion(movies.results)
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
    }

    private func loadAndSetImages(to movies: [MWMovie]) {
        for movie in movies {
            MWImageLoadingHelper.sh.loadMovieImage(for: movie)
        }
    }

    private func setGenres( to movies: [MWMovie]) {
        for movie in movies {
            movie.setMovieGenres(genres: MWSys.sh.genres)
        }
    }
}
