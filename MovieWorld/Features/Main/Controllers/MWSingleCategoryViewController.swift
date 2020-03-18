//
//  MWSingleCategoryViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/18/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWSingleCategoryViewController: MWViewController {
    
    private var movies: [MWMovie] = [] {
        didSet {
            self.tableView.reloadData()
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
    
    init(movies: [MWMovie]) {
        super.init()
        self.movies = movies
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initController() {
           super.initController()
           
           let view = self.tableView
           contentView.addSubview(view)
           
           view.snp.makeConstraints { (make) in
               make.edges.equalToSuperview()
           }
       }
}

extension MWSingleCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.singleCategoryTableViewCellId) as? MWSingleMovieInCategoryCell
            else { fatalError("The registered type for the cell does not match the casting") }
        
        cell.set(movie: movies[indexPath.row])
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
