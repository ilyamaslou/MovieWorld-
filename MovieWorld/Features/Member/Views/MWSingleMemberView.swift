//
//  MWSingleMemberView.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/6/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWSingleMemberView: UIView {

    //MARK: - insets and size variables

    private let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let collectionViewSize = CGSize(width: .zero, height: 237)

    //MARK:- gui variables

    lazy var memberCellView = MWCastMemberView()

    private lazy var titleForCollectionView: UILabel = {
        let label = UILabel()
        label.text = "Filmography".local()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
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

    lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines = 0
        return label
    }()

    //MARK: - initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    private func addSubviews() {
        self.addSubview(self.memberCellView)
        self.addSubview(self.titleForCollectionView)
        self.addSubview(self.collectionView)
        self.addSubview(self.roleLabel)
        self.addSubview(self.bioLabel)
    }

    override func updateConstraints() {
        self.memberCellView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(self.edgeInsets.top)
            make.left.right.equalToSuperview()
        }

        self.titleForCollectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.memberCellView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(self.edgeInsets.left)
            make.right.equalToSuperview()
        }

        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleForCollectionView.snp.bottom).offset(self.edgeInsets.top)
            make.right.left.equalToSuperview()
            make.height.equalTo(self.collectionViewSize.height)
        }

        self.roleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom).offset(self.edgeInsets.top)
            make.left.equalToSuperview().offset(self.edgeInsets.left)
            make.right.equalToSuperview()
        }

        self.bioLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.roleLabel.snp.bottom).offset(self.edgeInsets.top)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.bottom.equalToSuperview().inset(10)
        }

        super.updateConstraints()
    }
}
