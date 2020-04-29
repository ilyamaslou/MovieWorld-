//
//  MWMainTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/25/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWMainTableViewCell: UITableViewCell {

    var movies: [MWMovie] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    private var category: String = ""

    private lazy var showAllView: MWTitleButtonView = {
        let view = MWTitleButtonView()
        view.titleSize = 24
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MWMainCollectionViewCell.self, forCellWithReuseIdentifier: Constants.mainScreenCollectionViewCellId)

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
        collectionViewLayout.minimumInteritemSpacing = 8
        collectionViewLayout.sectionInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
        return collectionViewLayout
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movieImageUpdated),
                                               name: .movieImageUpdated, object: nil)

        backgroundColor = .white
        self.contentView.addSubview(self.showAllView)
        self.contentView.addSubview(self.collectionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        self.showAllView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(7)
            make.bottom.equalTo(self.collectionView.snp.top).offset(-12)
        }

        self.collectionView.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(237)
        }

        super.updateConstraints()
    }

    func set(categoryName: MWCategories, totalResults: (Int, Int)?) {
        self.category = categoryName.rawValue
        self.showAllView.title = categoryName.rawValue
        self.showAllView.controllerToPushing = MWSingleCategoryViewController(movies: self.movies,
                                                                              category: categoryName,
                                                                              totalResultsInfo: totalResults)
        setNeedsUpdateConstraints()
    }

    @objc private func movieImageUpdated() {
        self.collectionView.reloadData()
    }
}

extension MWMainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.mainScreenCollectionViewCellId,
            for: indexPath) as? MWMainCollectionViewCell else { fatalError("The registered type for the cell does not match the casting") }

        if self.movies.count > 0 {
            let singleFilm = self.movies[indexPath.item]
            cell.set(movie: singleFilm)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MWI.s.pushVC(MWSingleMovieViewController(movie: self.movies[indexPath.item]))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 237)
    }
}
