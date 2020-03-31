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
    
    private var filteredMovies: [MWMovie] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var movieGenres: [(String, Bool)] = []
    private var filteredGenres: Set<String> = []
    
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
        return collectionView
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 8
        collectionViewLayout.sectionInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return collectionViewLayout
    }()
    
    init(movies: [MWMovie]) {
        super.init()
        self.title = "Movies"
        self.movies = movies
        self.filteredMovies = movies
        self.setUpGenres()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initController() {
        super.initController()
        
        contentView.addSubview(self.collectionView)
        contentView.addSubview(self.tableView)
        
        self.collectionView.snp.makeConstraints {(make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            //TODO: change this later
            make.height.equalTo(70)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(16)
        }
    }
    
    private func setUpGenres() {
        var uniqueGenres: Set<String> = []
        for movie in movies {
            guard let genres = movie.movieGenres else { return }
            for genre in genres {
                uniqueGenres.insert(genre)
            }
        }
        
        uniqueGenres.forEach { movieGenres.append(($0, false)) }
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
        for (id,(genre, isSelected)) in movieGenres.enumerated() {
            if genreToChange == genre {
                movieGenres[id].1 = !isSelected
            }
        }
    }
}

extension MWSingleCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.singleCategoryTableViewCellId) as? MWSingleMovieInCategoryCell
            else { fatalError("The registered type for the cell does not match the casting") }
        
        cell.set(movie: filteredMovies[indexPath.row])
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
        return 16
    }
}

extension MWSingleCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieGenres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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



