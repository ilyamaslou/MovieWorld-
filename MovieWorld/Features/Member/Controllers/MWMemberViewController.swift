//
//  MWMemberViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWMemberViewController: MWViewController {
    
    private let offsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private var member: Any?
    private var memberInfo: MWPerson?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.bounces  = true
        return view
    }()
    
    private lazy var contentViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var memberCellView: MWCastMemberCellView = MWCastMemberCellView()
    
    private lazy var showAllView: MWTitleButtonView = {
        let view = MWTitleButtonView()
        view.title = "Cast"
        return view
    }()
    
    //    private lazy var memberMoviesCollectionView: UICollectionView = {
    //        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.memberMoviesCollectionViewLayout)
    //        collectionView.delegate = self
    //        collectionView.dataSource = self
    //        collectionView.register(MWCastMemberCollectionViewCell.self, forCellWithReuseIdentifier: Constants.singleCastMemberCollectionViewCellId)
    //
    //        collectionView.translatesAutoresizingMaskIntoConstraints = false
    //        collectionView.backgroundColor = .white
    //        collectionView.contentInsetAdjustmentBehavior = .never
    //        collectionView.showsVerticalScrollIndicator = false
    //        collectionView.showsHorizontalScrollIndicator = false
    //
    //        return collectionView
    //    }()
    //
    //    private lazy var memberMoviesCollectionViewLayout: UICollectionViewFlowLayout = {
    //        let collectionViewLayout = UICollectionViewFlowLayout()
    //        collectionViewLayout.scrollDirection = .horizontal
    //        collectionViewLayout.minimumLineSpacing = 16
    //        collectionViewLayout.minimumInteritemSpacing = 16
    //        collectionViewLayout.sectionInset = UIEdgeInsets(top: .zero, left: self.offsets.left, bottom: .zero, right: self.offsets.right)
    //        collectionViewLayout.itemSize = CGSize(width: 130, height: 237)
    //        return collectionViewLayout
    //    }()
    
    private lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17,  weight: .bold)
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines = 0
        return label
    }()
    
    init(member: Any?) {
        super.init()
        self.member = member
        self.loadMemberInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initController() {
        super.initController()
        navigationItem.largeTitleDisplayMode = .never
        
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentViewContainer)
        self.contentViewContainer.addSubview(self.memberCellView)
        self.contentViewContainer.addSubview(self.roleLabel)
        self.contentViewContainer.addSubview(self.bioLabel)
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentViewContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(self.view.snp.width)
        }
        
        self.memberCellView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(self.offsets.top)
        }
        
        self.roleLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(self.offsets.left)
            make.top.equalTo(self.memberCellView.snp.bottom).offset(self.offsets.top)
        }
        
        self.bioLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.roleLabel.snp.bottom).offset(self.offsets.top)
            make.right.equalToSuperview().inset(self.offsets.right)
            make.left.equalToSuperview().offset(self.offsets.left)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func loadMemberInfo() {
        if let castMember = self.member as? MWMovieCastMember,
            let id = castMember.id {
            self.load(id: id)
        } else if let crewMember = self.member as? MWMovieCrewMember,
            let id = crewMember.id {
            self.load(id: id)
        }
    }
    
    private func load(id: Int) {
        let urlPath = "person/\(id)"
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (info: MWPerson)  in
                            guard let self = self else { return }
                            self.memberInfo = info
                            self.updateView()
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
    }
    
    private func updateView() {
        self.roleLabel.text = self.memberInfo?.department
        self.bioLabel.text = self.memberInfo?.biography
        guard let castMember = self.member as? MWMovieCastMember else { return }
        self.memberCellView.set(castMember: castMember, birthday: self.memberInfo?.birthday ?? "")
    }
}

//extension MWMemberViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: Constants.singleMovieGalleryCollectionViewCellId,
//            for: indexPath) as? MWMovieGalleryCollectionViewCell else { fatalError("The registered type for the cell does not match the casting") }
//        return cell
//    }
//}
