//
//  MWSingleCategoryViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/18/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWSingleCategoryViewController: MWViewController {

    private var page: Int = 2
    private var totalPages: Int = 0
    private var totalItems: Int = 0
    private var isRequestBusy: Bool = false
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

    private var movieGenres: [(String, Bool)] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    private var filteredGenres: Set<String> = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MWSingleMovieInCategoryCell.self, forCellReuseIdentifier: Constants.singleCategoryTableViewCellId)
        return tableView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MWGenreCollectionViewCell.self, forCellWithReuseIdentifier: Constants.singleCategoryGenresCollectionViewCellId)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
        return collectionView
    }()

    private lazy var collectionViewLayout: MWGroupsCollectionViewLayout = {
        let collectionViewLayout = MWGroupsCollectionViewLayout()
        collectionViewLayout.delegate = self
        return collectionViewLayout
    }()

    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .whiteLarge
        view.color = UIColor(named: "accentColor")
        return view
    }()

    init(title: String = "Movies",
         movies: [MWMovie],
         category: MWCategories? = nil,
         totalResultsInfo: (totalResults: Int, totalPages: Int)? = (0, 0)) {
        super.init()
        self.title = title
        self.category = category
        self.totalPages = totalResultsInfo?.totalPages ?? 0
        self.totalItems = totalResultsInfo?.totalResults ?? 0

        self.updateTableAndCollectionView(movies: movies)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initController() {
        super.initController()

        self.contentView.addSubview(self.collectionView)
        self.contentView.addSubview(self.tableView)
        self.contentView.addSubview(self.loadingSpinner)

        self.collectionView.snp.makeConstraints {(make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(70)
        }

        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(16)
        }

        self.loadingSpinner.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    func updateTableAndCollectionView(movies: [MWMovie]) {
        self.movies = movies
        self.setUpGenres()
    }

    private func setUpGenres() {
        var oldGenres: Set<String> = []
        self.movieGenres.forEach { oldGenres.insert($0.0) }

        var oldAndNewGenres: Set<String> = []
        for movie in self.movies {
            guard let genres = movie.movieGenres else { return }
            for genre in genres {
                oldAndNewGenres.insert(genre)
            }
        }
        let newGenres = oldAndNewGenres.subtracting(oldGenres)
        newGenres.forEach { self.movieGenres.append(($0, false)) }

        self.movieGenres.sort { $0.0 < $1.0 }
    }

    private func updateTableByGenres() {
        var tempFilteredMovies: Set<MWMovie> = []

        if self.filteredGenres.isEmpty {
            self.filteredMovies = self.movies
            return
        }

        for movie in self.movies {
            for genre in self.filteredGenres {
                guard let movieGenres = movie.movieGenres else { return }
                for movieGenre in movieGenres {
                    if movieGenre == genre {
                        tempFilteredMovies.insert(movie)
                    }
                }
            }
        }

        self.filteredMovies = Array(tempFilteredMovies)
    }

    private func selectUnselectGenre(genreToChange: String) {
        for (id, (genre, isSelected)) in self.movieGenres.enumerated() {
            if genreToChange == genre {
                self.movieGenres[id].1 = !isSelected
            }
        }
    }
}

extension MWSingleCategoryViewController: UITableViewDataSource, UITableViewDelegate {

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
        MWI.s.pushVC(MWSingelMovieViewController(movie: self.movies[indexPath.row]))
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0  else { return 0 }
        return 16
    }
}

extension MWSingleCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieGenres.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.singleCategoryGenresCollectionViewCellId,
            for: indexPath) as? MWGenreCollectionViewCell else { fatalError("The registered type for the cell does not match the casting") }

        cell.set(genreWithSelection: self.movieGenres[indexPath.item])

        cell.selectedGenre = { [weak self] genre, isSelected in
            guard let self = self else { return }
            if isSelected {
                self.filteredGenres.insert(genre)
            } else {
                self.filteredGenres.remove(genre)
            }
            self.selectUnselectGenre(genreToChange: genre)
            self.updateTableByGenres()
        }
        return cell
    }
}

extension MWSingleCategoryViewController: MWGroupsLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        widthForLabelAtIndexPath indexPath: IndexPath) -> CGFloat {
        return self.movieGenres[indexPath.item].0.textWidth(font: .systemFont(ofSize: 13)) + 24
    }
}

//MARK: Pagination
extension MWSingleCategoryViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rowUnit = self.movies[indexPath.row]
        guard movies.count > 5 else { return }
        let unit = self.movies[self.movies.count - 5]
        if self.totalItems > self.movies.count,
            rowUnit.id == unit.id {
            self.loadUnits()
            self.loadingSpinner.startAnimating()
        }
    }

    private func loadUnits() {
        guard !self.isRequestBusy,
            self.movies.count != self.totalItems else { return }
        self.isRequestBusy = true

        self.loadMovies { [weak self] (movies) in
            guard let self = self else { return }
            self.isRequestBusy = false
            self.page += 1
            self.collectionViewLayout.cache = []
            self.movies += movies
            self.setUpGenres()
            self.loadingSpinner.stopAnimating()
        }
    }

    private func loadMovies( completion: @escaping ([MWMovie]) -> Void) {
        guard let category = self.category else { return }
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
                            self.setImages(to: movies.results, in: category.rawValue)
                            completion(movies.results)
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }

                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
    }

    private func setGenres(to movies: [MWMovie]){
        for movie in movies {
            movie.setFilmGenres(genres: MWSys.sh.genres)
        }
    }

    private func setImages(to movies: [MWMovie], in category: String) {
        for movie in movies {
            MWImageLoadingHelper.sh.loadMovieImage(for: movie, in: category)
        }
    }
}
