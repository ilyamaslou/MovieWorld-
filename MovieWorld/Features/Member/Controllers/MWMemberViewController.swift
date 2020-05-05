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

    //MARK: - insets and size variables

    private let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let collectionViewSize = CGSize(width: .zero, height: 237)

    //MARK: - private variables

    private var member: Any?
    private var memberInfo: MWMemberDetails?
    private var memberMovies: [MWMovie] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    private var isFavorite: Bool = false {
        didSet {
            self.navigationItem.rightBarButtonItem?.image = isFavorite ?  UIImage(named: "selectedFaovoriteIcon") : UIImage(named: "unselectedFavoriteIcon")
        }
    }

    //MARK:- gui variables

    private lazy var rightBarButtonDidFavoriteItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "unselectedFavoriteIcon"),
                                                                                      style: .plain,
                                                                                      target: self,
                                                                                      action: #selector(self.didFavoriteButtonTapped))

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

    private lazy var memberCellView = MWCastMemberView()

    private lazy var titleForCollectionView: UILabel = {
        let label = UILabel()
        label.text = "Filmography"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MWMainCollectionViewCell.self, forCellWithReuseIdentifier: MWMainCollectionViewCell.reuseIdentifier)

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
        label.font = .systemFont(ofSize: 17, weight: .bold)
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

    //MARK: - initialization

    init(member: Any?) {
        super.init()
        self.navigationItem.setRightBarButton(self.rightBarButtonDidFavoriteItem, animated: true)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.imageLoaded),
                                               name: .movieImageUpdated, object: nil)
        self.member = member

        self.fetchIsFavorite()
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
            make.top.equalToSuperview().offset(self.edgeInsets.top)
            make.left.right.equalToSuperview()
        }

        self.titleForCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.memberCellView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(self.edgeInsets.left)
            make.right.equalToSuperview()
        }

        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleForCollectionView.snp.bottom).offset(self.edgeInsets.top)
            make.right.left.equalToSuperview()
            make.height.equalTo(self.collectionViewSize.height)
        }

        self.roleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom).offset(self.edgeInsets.top)
            make.left.equalToSuperview().offset(self.edgeInsets.left)
            make.right.equalToSuperview()
        }

        self.bioLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.roleLabel.snp.bottom).offset(self.edgeInsets.top)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    //MARK: - view controller life cycle

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .always
    }

    //MARK:- request functions

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

    //MARK:- Actions

    private func updateView() {
        self.roleLabel.text = self.memberInfo?.department
        self.bioLabel.text = self.memberInfo?.biography
        guard let castMember = self.member as? MWMovieCastMember else { return }
        self.memberCellView.set(castMember: castMember, birthday: self.memberInfo?.birthday ?? "")
    }

    @objc private func imageLoaded() {
        self.collectionView.reloadData()
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
