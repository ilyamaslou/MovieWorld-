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
    
    private lazy var repeatingFilms: [MWFilm] = {
        let singleFilm = MWFilm(filmName: "21 Bridges", releaseYear: 2019, filmGenres: ["Drama", "Comedy", "Foreign"])
        let films = Array(repeating: singleFilm, count: 10)
        return films
    }()
    
    private lazy var repeatingFilms2: [MWFilm] = {
        let singleFilm = MWFilm(filmName: "The Good Liar", releaseYear: 2019, filmGenres: ["Drama", "Comedy", "Foreign"])
        let films = Array(repeating: singleFilm, count: 10)
        return films
    }()
    
    private lazy var moviesByCategories: [String: [MWFilm]] = ["New": repeatingFilms,
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

