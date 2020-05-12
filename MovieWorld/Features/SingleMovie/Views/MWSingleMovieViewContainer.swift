//
//  MWSingleMovieViewContainer.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/6/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import YouTubePlayer

class MWSingleMovieViewContainer: UIView {

    //MARK:- insets and sizes variables

    private let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let castCollectionViewHeight: Int = 237
    private let galleryCollectionViewHeight: Int = 200
    private let moviePlayerHeight: Int = 180

    //MARK:- gui variables

    lazy var movieCellView = MWSingleMovieView()
    lazy var moviePlayer = YouTubePlayerView()

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = UIColor(named: "accentColor")
        view.startAnimating()
        return view
    }()

    private lazy var descriptionContainerView = UIView()

    lazy var movieRuntimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description".local()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    lazy var descriptionTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: 17)
        return textLabel
    }()

    lazy var showAllView: MWTitleButtonView = {
        let view = MWTitleButtonView()
        view.title = "Cast".local()
        return view
    }()

    lazy var castCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.castCollectionViewLayout)
        collectionView.register(MWCastMemberCollectionViewCell.self, forCellWithReuseIdentifier: MWCastMemberCollectionViewCell.reuseIdentifier)

        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    private lazy var castCollectionViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 16
        collectionViewLayout.minimumInteritemSpacing = 16
        collectionViewLayout.sectionInset = UIEdgeInsets(top: .zero, left: self.edgeInsets.left, bottom: .zero, right: self.edgeInsets.right)
        collectionViewLayout.itemSize = CGSize(width: 130, height: 237)
        return collectionViewLayout
    }()

    private lazy var galleryLabel: UILabel = {
        let label = UILabel()
        label.text = "Trailers and gallery".local()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    lazy var galleryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.galleryViewLayout)
        collectionView.register(MWMovieGalleryCollectionViewCell.self, forCellWithReuseIdentifier: MWMovieGalleryCollectionViewCell.reuseIdentifier)

        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    private lazy var galleryViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 16
        collectionViewLayout.minimumInteritemSpacing = 16
        collectionViewLayout.sectionInset = UIEdgeInsets(top: .zero, left: self.edgeInsets.left, bottom: .zero, right: self.edgeInsets.right)
        collectionViewLayout.itemSize = CGSize(width: 500, height: 200)
        return collectionViewLayout
    }()

    // MARK: - constraints

    override func updateConstraints() {
        self.addSubview(self.movieCellView)
        self.addSubview(self.moviePlayer)
        self.addSubview(self.loadingIndicator)
        self.addSubview(self.descriptionContainerView)
        self.addSubview(self.showAllView)
        self.addSubview(self.castCollectionView)
        self.addSubview(self.galleryLabel)
        self.addSubview(self.galleryCollectionView)

        self.descriptionContainerView.addSubview(self.descriptionLabel)
        self.descriptionContainerView.addSubview(self.movieRuntimeLabel)
        self.descriptionContainerView.addSubview(self.descriptionTextLabel)

        self.movieCellView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(self.edgeInsets.top)
            make.left.right.equalToSuperview()
        }

        self.moviePlayer.snp.updateConstraints { (make) in
            make.top.equalTo(self.movieCellView.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.height.equalTo(self.moviePlayerHeight)
        }

        self.loadingIndicator.snp.updateConstraints { (make) in
            make.center.equalTo(self.moviePlayer.snp.center)
        }

        self.descriptionContainerView.snp.updateConstraints { (make) in
            make.top.equalTo(self.moviePlayer.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
        }

        self.descriptionLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }

        self.movieRuntimeLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(self.edgeInsets.top)
            make.left.right.equalToSuperview()
        }

        self.descriptionTextLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.movieRuntimeLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }

        self.showAllView.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.descriptionContainerView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(self.edgeInsets.left)
            make.right.equalToSuperview().inset(26)
        }

        self.castCollectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.showAllView.snp.bottom).offset(self.edgeInsets.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.castCollectionViewHeight)
        }

        self.galleryLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.castCollectionView.snp.bottom).offset(self.edgeInsets.top)
            make.left.equalToSuperview().offset(self.edgeInsets.left)
            make.right.equalToSuperview()
        }

        self.galleryCollectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.galleryLabel.snp.bottom).offset(self.edgeInsets.top)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(self.galleryCollectionViewHeight)
        }

        super.updateConstraints()
    }
}
