//
//  MWSingleCollectionViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/9/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWSingleCollectionViewController: MWViewController {

    //MARK: - private variables

    private var collectionIndex: Int?
    private var collection: MWCategoryModel? {
        didSet {
            self.tableView.reloadData()
        }
    }

    //MARK:- gui variables

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MWSingleMovieInCategoryCell.self, forCellReuseIdentifier: MWSingleMovieInCategoryCell.reuseIdentifier)
        return tableView
    }()

    private lazy var textView = UITextView()

    //MARK: - initialization

    init(collection: MWCollectionModel) {
        super.init()
        self.title = collection.name
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.imageLoaded),
                                               name: .movieImageUpdated, object: nil)

        self.collectionIndex = collection.id
        self.loadCollection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - constraints

    override func updateViewConstraints() {
        self.contentView.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateViewConstraints()
    }

    //MARK: - request

    private func loadCollection() {
        guard let collectionIndex = self.collectionIndex else { return }
        let urlPath = String(format: URLPaths.collectionOfMoviesById, collectionIndex)

        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (collection: MWCategoryModel)  in
                            guard let self = self else { return }
                            self.collection = collection
                            self.loadAndSetImages()
                            self.setGenres()
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
    }

    private func loadAndSetImages() {
        guard let movies = self.collection?.parts else { return }
        for movie in movies {
            MWImageLoadingHelper.sh.loadMovieImage(for: movie)
        }
    }

    //MARK: - setter

    private func setGenres() {
        guard let movies = self.collection?.parts else { return }
        for movie in movies {
            movie.setFilmGenres(genres: MWSys.sh.genres)
        }
    }

    //MARK: - update tableView action

    @objc private func imageLoaded() {
        self.tableView.reloadData()
    }
}

extension MWSingleCollectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collection?.parts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWSingleMovieInCategoryCell.reuseIdentifier, for: indexPath)
        guard let movie = self.collection?.parts?[indexPath.row] else { return cell }
        (cell as? MWSingleMovieInCategoryCell)?.set(movie: movie)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = self.collection?.parts?[indexPath.row] else { return }
        MWI.s.pushVC(MWSingleMovieViewController(movie: movie))
    }
}
