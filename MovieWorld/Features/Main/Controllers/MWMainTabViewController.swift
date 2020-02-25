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
        let singleFilm = MWFilm(filmName: "21 Bridges", releaseYear: 2018, filmCountry: "USA")
        let films = Array(repeating: singleFilm, count: 6)
        return films
    }()
   
    private lazy var moviesByCategories: [String: [MWFilm]] = ["New": repeatingFilms,
                                                           "Movies": repeatingFilms,
                                                           "Series and Shows": repeatingFilms,
                                                           "Animated Movies": repeatingFilms]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MWMainTableViewCell.self, forCellReuseIdentifier: Constants.mainScreenTableViewCellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
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
        return moviesByCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
        withIdentifier: Constants.mainScreenTableViewCellId) as! MWMainTableViewCell
        
        cell.set(categoryName: Array(self.moviesByCategories.keys)[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}

