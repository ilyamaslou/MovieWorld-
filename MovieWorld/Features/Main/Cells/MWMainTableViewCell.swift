//
//  MWMainTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/25/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import SnapKit

class MWMainTableViewCell: UITableViewCell {
    
    var movies: [MWMovie] = [] {
        didSet {
            self.collectionView.reloadData()
            setNeedsUpdateConstraints()
        }
    }
    
    private lazy var showAllButton = MWCustomButton()
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24,  weight: .bold)
        return label
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
        
        backgroundColor = .white
        self.contentView.addSubview(self.categoryLabel)
        self.contentView.addSubview(self.showAllButton)
        self.contentView.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        self.categoryLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.bottom.equalTo(self.collectionView.snp.top).inset(-12)
            make.right.equalTo(self.showAllButton.snp.left)
        }
        
        self.showAllButton.snp.updateConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(7)
            make.bottom.equalTo(self.collectionView.snp.top).inset(-12)
            make.left.equalTo(self.categoryLabel.snp.right)
        }
        
        self.collectionView.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(237)
        }
        
        super.updateConstraints()
    }
    
    func set(categoryName: String) {
        self.categoryLabel.text = categoryName
        
        setNeedsUpdateConstraints()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 237)
    }
}
