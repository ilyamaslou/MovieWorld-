//
//  MWMemberViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWMemberViewController: MWViewController {

    //MARK: - size variable

    private var cellHeight = 237
    private var cellWidth: Int {
        return ((Int(self.view.frame.size.width) - 48) / 3)
    }

    //MARK: - private variables

    private var member: Personalized?
    private var memberInfo: MWMemberDetails?
    private var memberMovies: [MWMovie] = [] {
        didSet {
            self.contentViewContainer.collectionView.reloadData()
        }
    }

    private var isFavorite: Bool = false {
        didSet {
            self.navigationItem.rightBarButtonItem?.image = isFavorite
                ? UIImage(named: "selectedFaovoriteIcon")
                : UIImage(named: "unselectedFavoriteIcon")
        }
    }

    private var oldIsFavorite: Bool = false

    //MARK:- gui variables

    private lazy var rightBarButtonDidFavoriteItem = UIBarButtonItem(image: UIImage(named: "unselectedFavoriteIcon"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.didFavoriteButtonTap))

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.bounces  = true
        return view
    }()

    private lazy var contentViewContainer: MWSingleMemberView = {
        let view = MWSingleMemberView()
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        return view
    }()

    //MARK: - initialization

    init(member: Personalized?) {
        super.init()
        self.navigationItem.setRightBarButton(self.rightBarButtonDidFavoriteItem, animated: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.imageLoaded),
                                               name: .movieImageUpdated, object: nil)
        self.member = member
        self.checkIsFavorite()
        self.oldIsFavorite = self.isFavorite

        self.loadMemberInfo()
        self.loadMemberMovies()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initController() {
        super.initController()
        self.navigationItem.largeTitleDisplayMode = .never

        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentViewContainer)
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.contentViewContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    //MARK: - view controller life cycle

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .always
        guard self.isFavorite != self.oldIsFavorite else { return }
        NotificationCenter.default.post(name: .actorIsFavoriteChanged, object: nil)
    }

    //MARK:- request functions

    private func loadMemberInfo() {
        guard let id = self.member?.id else { return }
        self.loadInfo(id: id)
    }

    private func loadInfo(id: Int) {
        let urlPath = String(format: URLPaths.personInfo, id)
        MWNet.sh.request(urlPath: urlPath,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (info: MWMemberDetails)  in
                            guard let self = self else { return }
                            self.memberInfo = info
                            self.updateView()
            },
                         errorHandler: { [weak self] (error) in
                            let message = error.getErrorDesription()
                            self?.errorAlert(message: message)
        })
    }

    private func loadMemberMovies() {
        let urlPath = URLPaths.personMovies
        var querryParameters: [String: String] = MWNet.sh.parameters
        querryParameters["query"] = self.member?.name

        MWNet.sh.request(urlPath: urlPath,
                         querryParameters: querryParameters,
                         succesHandler: { [weak self] (moviesResponse: MWMwmberMoviesResponse) in
                            guard let self = self,
                                let results = moviesResponse.results,
                                let memberKnownForMovies = results.first?.knownFor else { return }

                            self.memberMovies = memberKnownForMovies
                            self.setGenres()
                            self.loadAndSetImages()
            },
                         errorHandler: { [weak self] (error) in
                            let message = error.getErrorDesription()
                            self?.errorAlert(message: message)

        })
    }

    private func loadAndSetImages() {
        for movie in self.memberMovies {
            MWImageLoadingHelper.sh.loadMovieImage(for: movie)
        }
    }

    //MARK: - fetch core data action for checking

    private func checkIsFavorite() {
        guard let member = self.member else { return }
        let result = MWCDHelp.sh.fetchFavoriteActor(mwMember: member)
        self.isFavorite = result != nil ? true : false
    }

    //MARK:- seter and getter for genres

    private func setGenres() {
        for movie in self.memberMovies {
            movie.setMovieGenres(genres: MWSys.sh.genres)
        }
    }

    //MARK:- Actions

    private func updateView() {
        self.contentViewContainer.roleLabel.text = self.memberInfo?.department
        self.contentViewContainer.bioLabel.text = self.memberInfo?.biography
        guard let castMember = self.member as? MWMovieCastMember else { return }
        self.contentViewContainer.memberCellView.set(castMember: castMember, birthday: self.memberInfo?.birthday ?? "")
    }

    @objc private func imageLoaded() {
        self.contentViewContainer.collectionView.reloadData()
    }

    @objc private func didFavoriteButtonTap() {
        self.isFavorite.toggle()
        guard let member = self.member else { return }
        self.isFavorite
            ? MWCDHelp.sh.saveFavoriteActor(mwMember: member)
            : MWCDHelp.sh.removeFavoriteActor(mwMember: member)
    }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource

extension MWMemberViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memberMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWMainCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MWMainCollectionViewCell else { return UICollectionViewCell() }

        if self.memberMovies.count > 0 {
            let singleMovie = self.memberMovies[indexPath.item]
            cell.set(movie: singleMovie)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MWI.s.pushVC(MWSingleMovieViewController(movie: self.memberMovies[indexPath.item]))
    }
}

//MARK:- UICollectionViewDelegateFlowLayout

extension MWMemberViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
}
