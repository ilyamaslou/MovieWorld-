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
    
    //MARK: Hardcoded values
    
    private lazy var repeatingFilms: [MWPopularMovie] = {
        let singleFilm = MWPopularMovie(filmName: "21 Bridges", releaseYear: "2019", filmGenresIds : [1,2,3])
        let films = Array(repeating: singleFilm, count: 10)
        return films
    }()
    
    private lazy var repeatingFilms2: [MWPopularMovie] = {
        let singleFilm = MWPopularMovie(filmName: "The Good Liar", releaseYear: "2019", filmGenresIds: [3,2,1])
        let films = Array(repeating: singleFilm, count: 10)
        return films
    }()
    
    private lazy var moviesByCategories: [String: [MWPopularMovie]] = ["New": repeatingFilms,
                                                               "Movies": repeatingFilms2,
                                                               "Series and Shows": repeatingFilms,
                                                               "Animated Movies": repeatingFilms2 + repeatingFilms]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
                         succesHandler: { [weak self] (movie: MWPopularMoviesResponse)  in
                            print(movie)
                            
        },
                         errorHandler: { () in

        })
    }
    
    private func errorAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.setValue(NSAttributedString(string: title,
                                          attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
                                                       NSAttributedString.Key.foregroundColor : UIColor.red])
            , forKey: "attributedTitle")

        
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
        
        cell.set(categoryName: category)
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

