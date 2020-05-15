//
//  MWSingelMovieViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import YouTubePlayer
import CoreData

class MWSingleMovieViewController: MWViewController {

    //MARK: - private variables

    private var coreDataMovie: Movie?

    private var isFavorite: Bool = false {
        didSet {
            self.navigationItem.rightBarButtonItem?.image = isFavorite ?  UIImage(named: "selectedFaovoriteIcon") : UIImage(named: "unselectedFavoriteIcon")
        }
    }

    private var oldIsFavorite: Bool = false

    private var movie: MWMovie? {
        didSet {
            self.contentViewContainer.castCollectionView.reloadData()
        }
    }

    private var movieFullCast: MWMovieCastResponse? {
        didSet {
            self.contentViewContainer.castCollectionView.reloadData()
        }
    }

    private var addittionalMovieInfo: MovieAdditionalInfo?
    private var movieDetails: MWMovieAdditionalInfo?
    private var gallery: MWMovieGallery = MWMovieGallery()
    private var galleryItems: [Any] = []
    private var imagesResponse: MWMovieImagesResponse?

    //MARK:- gui variables

    private lazy var rightBarButtonDidFavoriteItem = UIBarButtonItem( image: UIImage(named: "unselectedFavoriteIcon"),
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

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "accentColor")
        return refreshControl
    }()

    private lazy var contentViewContainer: MWSingleMovieViewContainer = {
        let view = MWSingleMovieViewContainer()
        view.galleryCollectionView.delegate = self
        view.galleryCollectionView.dataSource = self
        view.castCollectionView.delegate = self
        view.castCollectionView.dataSource = self
        view.moviePlayer.delegate = self
        return view
    }()

    //MARK: - initialization

    init(movie: MWMovie) {
        super.init()
        self.navigationItem.setRightBarButton(self.rightBarButtonDidFavoriteItem, animated: true)
        self.observeNotifications()
        self.setShowAllButtonTappedAction()

        self.movie = movie
        self.contentViewContainer.movieCellView.setView(movie: movie)
        self.contentViewContainer.movieCellView.setNeedsUpdateConstraints()

        self.fetchIsFavorite()
        self.oldIsFavorite = self.isFavorite

        self.loadMovieVideos()
        self.loadMovieCast()
        self.loadMovieAdditionalInfo()
        self.loadMovieImages()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initController() {
        super.initController()
        self.navigationItem.largeTitleDisplayMode = .never
        self.contentViewContainer.loadingIndicator.startAnimating()

        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentViewContainer)
        self.scrollView.addSubview(self.refreshControl)
    }

    private func observeNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.memberImageUpdated),
                                               name: .memberImageUpdated, object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.movieImagesCollectionUpdated),
                                               name: .movieImagesCollectionUpdated, object: nil)

    }

    //MARK: constraints

    override func updateViewConstraints() {
        self.scrollView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.contentViewContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(self.scrollView)
            make.width.equalTo(self.view.snp.width)
        }

        super.updateViewConstraints()
    }

    //MARK: - viewController life cycle

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .always
        guard self.isFavorite != self.oldIsFavorite else { return }
        NotificationCenter.default.post(name: .movieIsFavoriteChanged, object: nil)
        self.contentViewContainer.moviePlayer.clear()
    }

    //MARK:- request functions

    private func loadMovieVideos() {
        guard let movieId = self.movie?.id else { return }
        let urlPath = String(format: URLPaths.getMovieVideos, movieId)

        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (videos: MWMovieVideoResponse)  in
                            guard let self = self else { return }
                            self.gallery.videos.append(contentsOf: videos.results
                                .filter { $0.site == "YouTube" }
                                .compactMap { $0.key } )
                            self.setAndShowLoadedVideo(videoUrlKey: self.gallery.videos.first)
                            self.reloadGalleryItems()
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
    }

    private func loadMovieCast() {
        guard let movieId = self.movie?.id else { return }
        let urlPath = String(format: URLPaths.getMovieCredits, movieId)

        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (cast: MWMovieCastResponse)  in
                            self?.setCast(cast: cast)
            },
                         errorHandler: { [weak self] (error) in
                            let message = error.getErrorDesription()
                            self?.errorAlert(message: message)
        })
    }

    private func loadMovieAdditionalInfo() {
        guard let movieId = self.movie?.id else { return }
        let urlPath = String(format: URLPaths.movieAdditionalInfo, movieId)

        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (details: MWMovieAdditionalInfo)  in
                            guard let self = self else { return }
                            self.movieDetails = details
                            self.saveAdditionalInfo(info: details)
                            self.setDetails()
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
                            self.setFetchedAddittionalInfo()
        })
    }

    private func loadMovieImages() {
        guard let movieId = self.movie?.id else { return }
        let urlPath = String(format: URLPaths.movieImages, movieId)

        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (images: MWMovieImagesResponse)  in
                            guard let self = self else { return }
                            self.imagesResponse = images
                            MWImageLoadingHelper.sh.loadMovieImages(for: self.imagesResponse)
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
    }

    private func loadPeoplesImages<T>(to peoples: [T]) {
        if let peoples = peoples as? [MWMovieCastMember] {
            for people in peoples {
                MWImageLoadingHelper.sh.loadPersonImage(for: people, path: people.profilePath)
            }
        } else if let peoples = peoples as? [MWMovieCrewMember] {
            for people in peoples {
                MWImageLoadingHelper.sh.loadPersonImage(for: people, path: people.profilePath)
            }
        } else {
            return
        }
    }

    //MARK:- setters

    private func setCast(cast: MWMovieCastResponse) {
        self.movieFullCast = cast

        let sortedCast = cast.cast.sorted { (member1, member2: MWMovieCastMember) in
            guard let order1 = member1.order, let order2 = member2.order else { return false }
            return order1 < order2
        }
        self.movieFullCast?.cast = sortedCast

        guard let castMembers = self.movieFullCast?.cast,
            let crewMembers = self.movieFullCast?.crew else { return }
        self.loadPeoplesImages(to: castMembers)
        self.loadPeoplesImages(to: crewMembers)
    }

    private func setAndShowLoadedVideo(videoUrlKey: String?) {
        guard let key = videoUrlKey else { return }
        self.contentViewContainer.moviePlayer.loadVideoID(key)
    }

    private func setDetails() {
        self.contentViewContainer.descriptionTextLabel.text = self.movieDetails?.overview ?? ""
        guard let movieRuntime = self.movieDetails?.runtime, movieRuntime != 0 else { return }
        self.contentViewContainer.movieRuntimeLabel.text = "%d minutes".local(args: movieRuntime)
    }

    private func setShowAllButtonTappedAction() {
        self.contentViewContainer.showAllView.buttonDidTap = { [weak self] in
            guard let self = self else { return }
            MWI.s.pushVC(MWCastViewController(cast: self.movieFullCast))
        }
    }

    //MARK:- update view actions

    private func reloadGalleryItems() {
        self.galleryItems = self.gallery.getGalleryItems()
        self.contentViewContainer.galleryCollectionView.reloadData()
    }

    @objc private func memberImageUpdated() {
        self.contentViewContainer.castCollectionView.reloadData()
    }

    @objc private func movieImagesCollectionUpdated() {
        guard let response = self.imagesResponse?.movieImages else { return }
        self.gallery.images = response
        self.reloadGalleryItems()
    }

    @objc private func pullToRefresh() {
        self.loadMovieVideos()
        self.loadMovieCast()
        self.loadMovieAdditionalInfo()
        self.loadMovieImages()

        self.refreshControl.endRefreshing()
    }

    //MARK: - button tapped actions

    @objc private func didFavoriteButtonTap() {
        self.isFavorite.toggle()
        self.isFavorite ? self.save() : self.remove()
    }
}

//MARK:- UICollectionViewDelegate

extension MWSingleMovieViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.contentViewContainer.galleryCollectionView {
            return self.galleryItems.count
        }

        guard let movieCastCount = self.movieFullCast?.cast.count, movieCastCount >= 10
            else {
                return self.movieFullCast?.cast.count ?? 0
        }
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.contentViewContainer.galleryCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MWMovieGalleryCollectionViewCell.reuseIdentifier,
                for: indexPath)
            (cell as? MWMovieGalleryCollectionViewCell)?.set(galleryItem: self.galleryItems[indexPath.item])

            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWCastMemberCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MWCastMemberCollectionViewCell else { return UICollectionViewCell() }

        if let memberOfCast = self.movieFullCast?.cast[indexPath.item] {
            cell.set(actor: memberOfCast)
        }

        return cell
    }
}

//MARK:- UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension MWSingleMovieViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.contentViewContainer.castCollectionView {
            MWI.s.pushVC(MWMemberViewController(member: self.movieFullCast?.cast[indexPath.item]))
        }
    }
}

//MARK: CoreData Additional movie Info
extension MWSingleMovieViewController {
    private func fetchMovie() {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY id = %i and title = %@",
                                      self.movie?.id ?? 0,
                                      self.movie?.title ?? "")
        do {
            self.coreDataMovie = try managedContext.fetch(fetch).last
        } catch {
            print(error.localizedDescription)
        }
    }

    @discardableResult  private func fetchAdditionalInfo() -> MovieAdditionalInfo? {
        self.fetchMovie()
        return self.coreDataMovie?.additionalInfo
    }

    private func saveAdditionalInfo (info: MWMovieAdditionalInfo) {
        let fetchedInfo = self.fetchAdditionalInfo()

        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        if fetchedInfo == nil {
            let newAdditionalInfo = MovieAdditionalInfo(context: managedContext)
            newAdditionalInfo.adult = info.adult ?? false
            newAdditionalInfo.overview = info.overview
            newAdditionalInfo.runtime = Int64(info.runtime ?? 0)
            newAdditionalInfo.tagline = info.tagline
            self.coreDataMovie?.additionalInfo = newAdditionalInfo
        } else {
            guard let fetchedInfo = fetchedInfo else { return }
            fetchedInfo.adult = info.adult ?? false
            fetchedInfo.overview = info.overview
            fetchedInfo.runtime = Int64(info.runtime ?? 0)
            fetchedInfo.tagline = info.tagline
        }
        self.save(managedContext: managedContext)
    }

    private func setFetchedAddittionalInfo() {
        guard let fetchedInfo = self.fetchAdditionalInfo() else { return }
        var newInfo = MWMovieAdditionalInfo()
        newInfo.adult = fetchedInfo.adult
        newInfo.overview = fetchedInfo.overview
        newInfo.runtime = Int(fetchedInfo.runtime)
        newInfo.tagline = fetchedInfo.tagline

        self.movieDetails = newInfo
        self.setDetails()
    }

    private func save(managedContext: NSManagedObjectContext) {
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: CoreData FavoriteMovies
extension MWSingleMovieViewController {
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    @discardableResult private func fetchFavoriteMovie() -> Movie? {
        guard let id = self.movie?.id,
            let title = self.movie?.title,
            let releaseDate = self.movie?.releaseDate else { return Movie() }

        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY id = %i and title = %@ and releaseDate = %@ and favorite != nil", id, title, releaseDate)

        var result: [Movie] = []
        do {
            result = try managedContext.fetch(fetch)
        } catch {
            print(error.localizedDescription)
        }

        return result.first
    }

    private func fetchIsFavorite() {
        let result = self.fetchFavoriteMovie()
        if result != nil {
            self.isFavorite = true
        } else {
            self.isFavorite = false
        }
    }

    private func save() {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext

        let favoriteMovies = FavoriteMovies(context: managedContext)
        let newMovie = Movie(context: managedContext)
        newMovie.id = Int64(self.movie?.id ?? 0)
        newMovie.posterPath = self.movie?.posterPath
        newMovie.genreIds = self.movie?.genreIds
        newMovie.title = self.movie?.title
        newMovie.originalLanguage = self.movie?.originalLanguage
        newMovie.releaseDate = self.movie?.releaseDate

        if let movieRating = self.movie?.voteAvarage {
            newMovie.voteAvarage = movieRating
        }

        if let imageData = self.movie?.image {
            newMovie.movieImage = imageData
        }

        favoriteMovies.addToMovies(newMovie)

        self.saveContext(context: managedContext)
    }

    private func remove() {
        guard let movieToRemove = self.fetchFavoriteMovie() else { return }
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let favoriteMovies = FavoriteMovies(context: managedContext)

        favoriteMovies.removeFromMovies(movieToRemove)
        movieToRemove.favorite = nil

        self.saveContext(context: managedContext)
    }
}

//MARK: YouTubePlayerDelegate

extension MWSingleMovieViewController: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        self.contentViewContainer.loadingIndicator.stopAnimating()
    }
}
