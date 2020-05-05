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
    private var isRequestBusy: Bool = false
    private var shouldUseLoadingMethods = true

    //MARK: - size variable

    private let collectionViewHeight: Int = 70

    //MARK: - private variables

    private var category: MWCategories?

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

    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .whiteLarge
        view.color = UIColor(named: "accentColor")
        return view
    }()

    //MARK: - initialization

    init(title: String = "Movies",
         movies: [MWMovie],
         category: MWCategories? = nil,
         totalResultsInfo: (totalResults: Int, totalPages: Int)? = (0, 0)) {
        super.init()
        self.title = title
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
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.contentView.addSubview(self.collectionView.view)
        self.contentView.addSubview(self.tableView)
        self.contentView.addSubview(self.loadingSpinner)

        self.collectionView.view.snp.makeConstraints {(make) in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.collectionViewHeight)
        }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.view.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
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

    //MARK: - pagination check action

    private func checkFilteredMoviesOnFillness() {
        guard self.filteredMovies.count < 5, self.shouldUseLoadingMethods else { return }
        self.loadUnits()
    }

    //MARK:- update action

    @objc private func updateTableByGenres() {
        var tempFilteredMovies: [MWMovie] = []

        if self.collectionView.filteredGenres.isEmpty {
            self.filteredMovies = self.movies
            return
        }

        for genre in self.collectionView.filteredGenres {
            tempFilteredMovies.append(contentsOf: self.filteredMovies.filter{ ($0.movieGenres?.contains(genre) ?? false) })
        }

        self.filteredMovies = tempFilteredMovies
        self.checkFilteredMoviesOnFillness()
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate

extension MWSingleCategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MWSingleMovieInCategoryCell.reuseIdentifier) as? MWSingleMovieInCategoryCell
            else { fatalError("The registered type for the cell does not match the casting") }

        cell.set(movie: self.filteredMovies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MWI.s.pushVC(MWSingleMovieViewController(movie: self.filteredMovies[indexPath.row]))
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0  else { return 0 }
        return 16
    }
}

//MARK: Pagination
extension MWSingleCategoryViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rowUnit = self.filteredMovies[indexPath.row]
        guard self.filteredMovies.count > 4 else { return }
        let unit = self.filteredMovies[self.filteredMovies.count - 4]
        if self.totalItems > self.movies.count,
            rowUnit.id == unit.id {
            self.loadUnits()
        }
    }

    private func loadUnits() {
        self.loadingSpinner.startAnimating()
        guard !self.isRequestBusy,
            self.movies.count != self.totalItems else { return }
        self.isRequestBusy = true

        self.loadMovies{ [weak self] (movies) in
            guard let self = self else { return }
            self.isRequestBusy = false
            self.page += 1
            self.movies += movies
            self.updateTableByGenres()
            self.loadingSpinner.stopAnimating()
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
                            self.setGenresAndImages(to: movies.results)
                            completion(movies.results)
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }

                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
                            self.loadingSpinner.stopAnimating()
        })
    }

    private func setGenresAndImages(to movies: [MWMovie]) {
        for movie in movies {
            movie.setFilmGenres(genres: MWSys.sh.genres)
            MWImageLoadingHelper.sh.loadMovieImage(for: movie)
        }
    }
}
