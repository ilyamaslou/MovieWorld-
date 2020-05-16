//
//  ViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

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
        self.setUpView()

        self.loadMovies()
        self.group.notify(queue: .main, execute: self.tableView.reloadData)
    }

    //MARK: - constraints

    private func setUpView() {
        self.contentView.addSubview(self.tableView)
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
                                MWCDHelp.sh.saveMoviesInCategory(mwCategory: category, movies: movies.results)
                                self.refreshControl.endRefreshing()
                                self.group.leave()
                },
                             errorHandler: { [weak self] (error) in
                                guard let self = self else { return }
                                let message = error.getErrorDesription()
                                self.errorAlert(message: message)

                                let movies = MWCDHelp.sh.fetchMoviesByCategory(category: category).mwMovies
                                self.setMoviesToCategory(category: category, movies: movies)
                                self.refreshControl.endRefreshing()
                                self.group.leave()
            })
        }
    }

    //MARK: - setters

    private func setGenres(to movies: [MWMovie]) {
        for movie in movies {
            movie.setMovieGenres(genres: MWSys.sh.genres)
        }
    }

    private func setImages(to movies: [MWMovie], in category: String) {
        for movie in movies {
            MWImageLoadingHelper.sh.loadMovieImage(for: movie, in: category)
        }
    }

    private func setMoviesToCategory(category: MWMainCategories, movies: [MWMovie]) {
        self.moviesByCategories[category] = movies
        self.tableView.reloadData()
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
