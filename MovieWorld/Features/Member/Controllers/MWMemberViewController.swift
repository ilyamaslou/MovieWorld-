//
//  MWMemberViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import CoreData

class MWMemberViewController: MWViewController {

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
            self.navigationItem.rightBarButtonItem?.image = isFavorite ?  UIImage(named: "selectedFaovoriteIcon") : UIImage(named: "unselectedFavoriteIcon")
        }
    }

    private var oldIsFavorite: Bool = false

    //MARK:- gui variables

    private lazy var rightBarButtonDidFavoriteItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "unselectedFavoriteIcon"),
                                                                                      style: .plain,
                                                                                      target: self,
                                                                                      action: #selector(self.didFavoriteButtonTapped))

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
        self.fetchIsFavorite()
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
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentViewContainer)

        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.contentViewContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(self.view.snp.width)
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
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (info: MWMemberDetails)  in
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
        let urlPath = URLPaths.personMovies
        var querryParameters: [String: String] = MWNet.sh.parameters
        querryParameters["query"] = self.member?.name

        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: querryParameters,
                         succesHandler: { [weak self] (moviesResponse: MWPersonMoviesResponse)  in

                            guard let self = self,
                                let results = moviesResponse.results,
                                let memberKnownForMovies = results.first?.knownFor
                                else { return }

                            self.memberMovies = memberKnownForMovies
                            self.setGenres()
                            self.loadAndSetImages()
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)

        })
    }

    private func loadAndSetImages() {
        for movie in self.memberMovies {
            MWImageLoadingHelper.sh.loadMovieImage(for: movie)
        }
    }

    //MARK:- seter and getter for genres

    private func setGenres() {
        for movie in self.memberMovies {
            movie.setFilmGenres(genres: MWSys.sh.genres)
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

    @objc private func didFavoriteButtonTapped() {
        self.isFavorite = !self.isFavorite
        if self.isFavorite {
            self.save()
        } else {
            self.remove()
        }
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
            let singleFilm = self.memberMovies[indexPath.item]
            cell.set(movie: singleFilm)
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
        let width = ((Int(self.view.frame.size.width) - 48) / 3)
        return CGSize(width: width, height: 237)
    }
}

//MARK: CoreData FavoriteActors
extension MWMemberViewController {
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    @discardableResult private func fetchFavoriteActor() -> CastMember? {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<CastMember> = CastMember.fetchRequest()

        guard let member = self.member as? MWMovieCastMember,
            let id = member.id,
            let name = member.name else { return CastMember() }
        fetch.predicate = NSPredicate(format: "ANY id = %i and name = %@ and favoriteActors != nil", id, name)

        var result: [CastMember] = []
        do {
            result = try managedContext.fetch(fetch)
        } catch {
            print(error.localizedDescription)
        }

        return result.first
    }

    private func fetchIsFavorite() {
        let result = self.fetchFavoriteActor()
        if result != nil {
            self.isFavorite = true
        } else {
            self.isFavorite = false
        }
    }

    private func save() {
        guard let member = self.member as? MWMovieCastMember else { return }
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let favoriteActors = FavoriteActors(context: managedContext)
        let newMemmber = CastMember(context: managedContext)

        newMemmber.id = Int64(member.id ?? 0)
        newMemmber.profilePath = member.profilePath
        newMemmber.character = member.character
        newMemmber.order = Int64(member.order ?? 0)
        newMemmber.name = member.name

        if let imageData = member.image {
            newMemmber.image = imageData
        }

        favoriteActors.addToActors(newMemmber)

        self.saveContext(context: managedContext)
    }

    private func remove() {
        guard let memberToRemove = self.fetchFavoriteActor() else { return }
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let favoriteActors = FavoriteActors(context: managedContext)

        favoriteActors.removeFromActors(memberToRemove)
        memberToRemove.favoriteActors = nil
        self.saveContext(context: managedContext)
    }
}
