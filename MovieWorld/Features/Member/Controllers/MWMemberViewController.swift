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
    private var memberMovies: [MWMovie] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
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
    
    private lazy var titleForCollectionView: UILabel = {
        let label = UILabel()
        label.text = "Filmography"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17,  weight: .bold)
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(imageLoaded),
                                               name: .movieImageUpdated, object: nil)
        self.member = member
        self.loadMemberInfo()
        self.loadMemberMovies()
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
        self.contentViewContainer.addSubview(self.titleForCollectionView)
        self.contentViewContainer.addSubview(self.collectionView)
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
        
        self.titleForCollectionView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(self.offsets.left)
            make.top.equalTo(self.memberCellView.snp.bottom).offset(24)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview()
            make.top.equalTo(self.titleForCollectionView.snp.bottom).offset(self.offsets.top)
            make.height.equalTo(237)
        }
        
        self.roleLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(self.offsets.left)
            make.top.equalTo(self.collectionView.snp.bottom).offset(self.offsets.top)
        }
        
        self.bioLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.roleLabel.snp.bottom).offset(self.offsets.top)
            make.right.equalToSuperview().inset(self.offsets.right)
            make.left.equalToSuperview().offset(self.offsets.left)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionViewLayout.invalidateLayout()
    }
    
    private func loadMemberInfo() {
        if let castMember = self.member as? MWMovieCastMember,
            let id = castMember.id {
            self.loadInfo(id: id)
        } else if let crewMember = self.member as? MWMovieCrewMember,
            let id = crewMember.id {
            self.loadInfo(id: id)
        }
    }
    
    private func loadInfo(id: Int) {
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
    
    private func loadMemberMovies() {
        let urlPath = "search/person"
        var querryParameters: [String: String] = MWNet.sh.parameters
        querryParameters["query"] = self.getMemberName()
        
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: querryParameters,
                         succesHandler: { [weak self] (moviesResponse: MWPersonMoviesResponse)  in
                            
                            guard let self = self,
                                let results = moviesResponse.results,
                                let memberKnownForMovies = results.first?.knownFor
                                else { return }
                            
                            self.memberMovies = memberKnownForMovies
                            self.setGenres()
                            self.setImages()
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
                            
        })
    }
    
    private func getMemberName() -> String {
        var memberName: String = ""
        
        if let castMember = self.member as? MWMovieCastMember,
            let name = castMember.name {
            memberName = name
        } else if let crewMember = self.member as? MWMovieCrewMember,
            let name = crewMember.name {
            memberName = name
        }
        
        return memberName
    }
    
    private func setGenres() {
        for movie in self.memberMovies {
            movie.setFilmGenres(genres: MWSys.sh.genres)
        }
    }
    
    private func setImages() {
        for movie in self.memberMovies {
            MWImageLoadingHelper.sh.loadMovieImage(for: movie)
        }
    }
    
    private func updateView() {
        self.roleLabel.text = self.memberInfo?.department
        self.bioLabel.text = self.memberInfo?.biography
        guard let castMember = self.member as? MWMovieCastMember else { return }
        self.memberCellView.set(castMember: castMember, birthday: self.memberInfo?.birthday ?? "")
    }
    
    @objc private func imageLoaded() {
        self.collectionView.reloadData()
    }
}

extension MWMemberViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memberMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.mainScreenCollectionViewCellId,
            for: indexPath) as? MWMainCollectionViewCell else { fatalError("The registered type for the cell does not match the casting") }
        
        if self.memberMovies.count > 0 {
            let singleFilm = self.memberMovies[indexPath.item]
            cell.set(movie: singleFilm)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MWI.s.pushVC(MWSingelMovieViewController(movie: self.memberMovies[indexPath.item]))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((Int(self.view.frame.size.width) - 48) / 3)
        return CGSize(width: width, height: 237)
    }
}
