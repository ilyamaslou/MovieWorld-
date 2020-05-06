//
//  MWFilterGenresCollectionViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/27/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWGenresCollectionViewController: MWViewController {

    //MARK: - variables

    var movieGenres: [(String, Bool)] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    var filteredGenres: Set<String> = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    //MARK:- gui variables

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MWGenreCollectionViewCell.self, forCellWithReuseIdentifier: MWGenreCollectionViewCell.reuseIdentifier)

        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
        return collectionView
    }()

    lazy var collectionViewLayout: MWGroupsCollectionViewLayout = {
        let collectionViewLayout = MWGroupsCollectionViewLayout()
        collectionViewLayout.delegate = self
        return collectionViewLayout
    }()

    //MARK: - initialization and setting constraints

    override func initController() {
        super.initController()
        self.setUpGenres()
        self.contentView.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func setUpGenres() {
        self.movieGenres = []
        let allGenres = MWSys.sh.genres
        for genre in allGenres {
            self.movieGenres.append((genre.name, false))
        }
    }

    func updateGenresByFiltered() {
        for (id, genre) in self.movieGenres.enumerated() {
            for filteredGenre in self.filteredGenres {
                if filteredGenre == genre.0 {
                    self.movieGenres[id].1 = true
                }
            }
        }
    }

    private func selectUnselectGenre(genreToChange: String) {
        for (id, (genre, isSelected)) in self.movieGenres.enumerated() {
            if genreToChange == genre {
                self.movieGenres[id].1 = !isSelected
            }
        }
    }
}

//MARK:- UICollectionViewDataSource,  UICollectionViewDelegate

extension MWGenresCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieGenres.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWGenreCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MWGenreCollectionViewCell else { return UICollectionViewCell() }

        cell.set(genreWithSelection: self.movieGenres[indexPath.item])

        cell.selectedGenre = { [weak self] genre, isSelected in
            guard let self = self else { return }

            if isSelected {
                self.filteredGenres.insert(genre)
            } else {
                self.filteredGenres.remove(genre)
            }

            NotificationCenter.default.post(name: .genresChanged, object: nil)
            self.selectUnselectGenre(genreToChange: genre)
        }

        return cell
    }
}

extension MWGenresCollectionViewController: MWGroupsLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        widthForLabelAtIndexPath indexPath: IndexPath) -> CGFloat {
        return self.movieGenres[indexPath.item].0.textWidth(font: .systemFont(ofSize: 13)) + 24
    }
}
