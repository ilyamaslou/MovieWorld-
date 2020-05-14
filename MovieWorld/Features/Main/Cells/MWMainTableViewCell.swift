//
//  MWMainTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/25/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWMainTableViewCell: UITableViewCell {

    //MARK: - static variables

    static var reuseIdentifier: String = "MWMainTableViewCell"

    //MARK:- insets and size variables

    private var insets = UIEdgeInsets(top: 24, left: 16, bottom: -12, right: 7)
    private let imageSize = CGSize(width: 130, height: 237)

    //MARK: - private variable

    var movies: [MWMovie] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    //MARK: - private variable

    private var category: MWMainCategories?
    private var totalResults: (Int, Int)?

    //MARK:- gui variables

    private lazy var showAllView: MWTitleButtonView = {
        let view = MWTitleButtonView()
        view.titleSize = 24
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MWMainCollectionViewCell.self, forCellWithReuseIdentifier: MWMainCollectionViewCell.reuseIdentifier)

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
        collectionViewLayout.minimumInteritemSpacing = 8
        collectionViewLayout.sectionInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
        return collectionViewLayout
    }()

    //MARK: - initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.showAllView)
        self.contentView.addSubview(self.collectionView)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.movieImageUpdated),
                                               name: .movieImageUpdated, object: nil)
        self.setShowAllButtonTappedAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    override func updateConstraints() {
        self.showAllView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(self.insets.top)
            make.left.equalToSuperview().offset(self.insets.left)
            make.right.equalToSuperview().inset(self.insets)
            make.bottom.equalTo(self.collectionView.snp.top).offset(self.insets.bottom)
        }

        self.collectionView.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(self.imageSize.height)
        }

        super.updateConstraints()
    }

    //MARK: - setters

    func set(categoryName: MWMainCategories, totalResults: (Int, Int)?) {
        self.category = categoryName
        self.totalResults = totalResults
        self.showAllView.title = categoryName.rawValue
        self.setNeedsUpdateConstraints()
    }

    private func setShowAllButtonTappedAction() {
        self.showAllView.buttonIsTapped = {
            MWI.s.pushVC(MWSingleCategoryViewController(movies: self.movies,
                                                        category: self.category,
                                                        totalResultsInfo: self.totalResults))
        }
    }

    //MARK: - update collection action

    @objc private func movieImageUpdated() {
        self.collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDelegate

extension MWMainTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWMainCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MWMainCollectionViewCell else { return UICollectionViewCell() }

        if self.movies.count > 0 {
            let singleFilm = self.movies[indexPath.item]
            cell.set(movie: singleFilm)
        }
        return cell
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension MWMainTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MWI.s.pushVC(MWSingleMovieViewController(movie: self.movies[indexPath.item]))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.imageSize
    }
}
