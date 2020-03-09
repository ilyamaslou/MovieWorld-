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
    
    enum MWCategories: String, CaseIterable {
        case popularMovies = "Popular Movies"
        case nowPlayingMovies = "Now Playing Movies"
        case topRatedMovies = "Top Rated"
        case upcomingMovies = "Upcoming Movies"
    }
    
    private var moviesByCategories: [MWCategories: [MWMovie]] = [:] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var group = DispatchGroup()
    
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
        
        let view = self.tableView
        contentView.addSubview(view)
        
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.title = "Season".local()
        
        self.loadMovies()
        self.group.notify(queue: .main,execute: self.tableView.reloadData)
    }
    
    
    private func loadMovies() {
        
        var urlPath = ""
        
        for category in MWCategories.allCases {
            urlPath = self.getUrlPath(by: category)
            
            self.group.enter()
            MWNet.sh.request(urlPath: urlPath ,
                             querryParameters: MWNet.sh.parameters,
                             succesHandler: { [weak self] (movies: MWMoviesResponse)  in
                                guard let self = self else { return }
                                
                                var movies = movies.results
                                for (id, movie) in movies.enumerated() {
                                    let tempMovie = movie
                                    tempMovie.setFilmGenres(genres: MWSys.sh.genres)
                                    movies[id] = tempMovie
                                }
                                self.moviesByCategories[category] = movies
                                self.group.leave()
                },
                             errorHandler: { [weak self] (error) in
                                guard let self = self else { return }
                                
                                let message = error.getErrorDesription()
                                self.errorAlert(message: message)
                                self.moviesByCategories = [:]
                                self.group.leave()
                                
            })
        }
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
    
    @objc private func pullToRefresh() {
        self.loadMovies()
        self.group.notify(queue: .main,execute: self.tableView.reloadData)
        
        self.refreshControl.endRefreshing()
    }
}

extension MWMainTabViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.moviesByCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.mainScreenTableViewCellId) as? MWMainTableViewCell
            else { fatalError("The registered type for the cell does not match the casting") }
        
        let category = Array(self.moviesByCategories.keys)[indexPath.section]
        if let films = self.moviesByCategories[category] {
            cell.movies = films
            cell.set(categoryName: category.rawValue)
        }
        
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
