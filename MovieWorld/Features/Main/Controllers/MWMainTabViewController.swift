//
//  ViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import SnapKit

class MWMainTabViewController: MWViewController {
    
    enum MWCategories: String {
        case popularMovies = "Popular Movies"
        case nowPlayingMovies = "Now Playing Movies"
        case topRatedMovies = "Top Rated"
        case upcomingMovies = "Upcoming Movies"
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var moviesByCategories: [MWCategories: [MWMovie]] = [:]
    private lazy var genres: [Int: String] = [:]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.refreshControl = self.refreshControl
        tableView.register(MWMainTableViewCell.self, forCellReuseIdentifier: Constants.mainScreenTableViewCellId)
        return tableView
    }()
    
    override func initController() {
        super.initController()
        let view = tableView
        contentView.addSubview(view)
        
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.title = "Season"
        
        //MARK:Later wiil be in queue
        self.loadGenres()
        self.loadMovies(category: .popularMovies)
        self.loadMovies(category: .nowPlayingMovies)
        self.loadMovies(category: .topRatedMovies)
        self.loadMovies(category: .upcomingMovies)
    }
    
    private func loadGenres() {
        MWNet.sh.request(urlPath: URLPaths.getGenres ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (genres: MWGenreResponse)  in
                            guard let self = self else { return }
                            for genre in genres.genres{
                                self.genres[genre.id] = genre.name
                            }
                            self.tableView.reloadData()
                            
            },
                         errorHandler: { [weak self] (error) in
                            let message = MWNetError.getError(error: error)
                            self?.errorAlert(message: message)
        })
    }
    
    private func loadMovies(category: MWCategories) {
        
        let urlPath = getUrlPath(by: category)
        
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (movies: MWMoviesResponse)  in
                            guard let self = self else { return }
                            
                            var movies = movies.results
                            for (id, movie) in movies.enumerated() {
                                var tempMovie = movie
                                tempMovie.setFilmGenres(genres: self.genres)
                                movies[id] = tempMovie
                            }
                            self.moviesByCategories[category] = movies
                            
                            self.tableView.reloadData()
                            
            },
                         errorHandler: { [weak self] (error) in
                            let message = MWNetError.getError(error: error)
                            self?.errorAlert(message: message)
                            
        })
    }
    
    private func getUrlPath(by category: MWCategories) -> String {
        var urlPath = ""
        switch category {
        case .popularMovies:
            urlPath = URLPaths.popularMovies
        case .nowPlayingMovies:
            urlPath = URLPaths.nowPlayingMovies
        case .topRatedMovies:
            urlPath = URLPaths.topRatedMovies
        case .upcomingMovies:
            urlPath = URLPaths.upcomingMovies
        }
        
        return urlPath
    }
    
    
    @objc private func pullToRefresh() {
        
        //MARK:Later wiil be in queue
        self.loadMovies(category: .popularMovies)
        self.loadMovies(category: .nowPlayingMovies)
        self.loadMovies(category: .topRatedMovies)
        self.loadMovies(category: .upcomingMovies)
        
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    private func errorAlert( message: String) {
        
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.setValue(NSAttributedString(string: message,
                                          attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
                                                       NSAttributedString.Key.foregroundColor : UIColor.red])
            , forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: "OK",
                                        style: .cancel,
                                        handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert,animated: true)
    }
}

extension MWMainTabViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return moviesByCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.mainScreenTableViewCellId) as! MWMainTableViewCell
        
        let category = Array(self.moviesByCategories.keys)[indexPath.section]
        if let films = moviesByCategories[category] {
            cell.films = films
        }
        
        cell.set(categoryName: category.rawValue)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view  = UIView()
        view.backgroundColor = .white
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
}

