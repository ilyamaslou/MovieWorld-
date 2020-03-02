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
        case newMovies = "New"
        case topRatedMovies = "Top Rated"
        case popularTVShows = "Popular TV Shows"
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var moviesByCategories: [MWCategories: [MWPopularMovie]] = [:]
    
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
        self.loadPopularMovies()
    }
    
    private func loadPopularMovies() {
        MWNet.sh.request(urlPath: URLPaths.popularMovies,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (movies: MWPopularMoviesResponse)  in
                            
                            guard let self = self else { return }
                            self.moviesByCategories[MWCategories.popularMovies] = movies.results
                            self.tableView.reloadData()
                            
            },
                         errorHandler: { [weak self] (error) in
                            let message = MWNetError.getError(error: error)
                            self?.errorAlert(message: message)
                            
        })
    }
    
    @objc private func pullToRefresh() {
        self.loadPopularMovies()
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

