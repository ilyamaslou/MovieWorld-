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

class MWSingelMovieViewController: MWViewController {
    
    private let offsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private var cdMovie: Movie?
    
    private var isFavorite: Bool = false {
        didSet {
            self.navigationItem.rightBarButtonItem?.image = isFavorite ?  UIImage(named: "selectedFaovoriteIcon") : UIImage(named: "unselectedFavoriteIcon")
        }
    }
    
    private var movie: MWMovie = MWMovie() {
        didSet {
            self.castCollectionView.reloadData()
        }
    }
    
    private var movieFullCast: MWMovieCastResponse? {
        didSet {
            self.castCollectionView.reloadData()
            self.showAllView.controllerToPushing = MWCastViewController(cast: self.movieFullCast)
        }
    }
    
    private var addittionalMovieInfo: MovieAdditionalInfo?
    private var movieDetails: MWMovieAdditionalInfo?
    private var gallery: MWMovieGallery = MWMovieGallery()
    private var galleryItems: [Any] = []
    private var imagesResponse: MWMovieImagesResponse?
    
    private lazy var rightBarButtonDidFavoriteItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "unselectedFavoriteIcon"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(self.didFavoriteButtonTapped))
        return item
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.bounces  = true
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "accentColor")
        return refreshControl
    }()
    
    private lazy var contentViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var movieCellView: MWSingleMovieCellView = MWSingleMovieCellView()
    private lazy var moviePlayer: YouTubePlayerView = YouTubePlayerView()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = UIColor(named: "accentColor")
        view.startAnimating()
        return view
    }()
    
    private lazy var descriptionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var movieRuntimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15,  weight: .light)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.font = .systemFont(ofSize: 17,  weight: .bold)
        return label
    }()
    
    private lazy var descriptionTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .systemFont(ofSize: 17)
        return textLabel
    }()
    
    private lazy var showAllView: MWTitleButtonView = {
        let view = MWTitleButtonView()
        view.title = "Cast"
        return view
    }()
    
    private lazy var castCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.castCollectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MWCastMemberCollectionViewCell.self, forCellWithReuseIdentifier: Constants.singleCastMemberCollectionViewCellId)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        collectionViewLayout.sectionInset = UIEdgeInsets(top: .zero, left: self.offsets.left, bottom: .zero, right: self.offsets.right)
        collectionViewLayout.itemSize = CGSize(width: 130, height: 237)
        return collectionViewLayout
    }()
    
    private lazy var galleryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Trailers and gallery"
        label.font = .systemFont(ofSize: 17,  weight: .bold)
        return label
    }()
    
    private lazy var galleryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.galleryViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MWMovieGalleryCollectionViewCell.self, forCellWithReuseIdentifier: Constants.singleMovieGalleryCollectionViewCellId)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        collectionViewLayout.sectionInset = UIEdgeInsets(top: .zero, left: self.offsets.left, bottom: .zero, right: self.offsets.right)
        collectionViewLayout.itemSize = CGSize(width: 500, height: 200)
        return collectionViewLayout
    }()
    
    override func initController() {
        super.initController()
        navigationItem.largeTitleDisplayMode = .never
        self.loadingIndicator.startAnimating()
        
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentViewContainer)
        self.scrollView.addSubview(self.refreshControl)
        
        self.contentViewContainer.addSubview(self.movieCellView)
        self.contentViewContainer.addSubview(self.moviePlayer)
        self.contentViewContainer.addSubview(self.loadingIndicator)
        self.contentViewContainer.addSubview(self.descriptionContainerView)
        self.contentViewContainer.addSubview(self.showAllView)
        self.contentViewContainer.addSubview(self.castCollectionView)
        self.contentViewContainer.addSubview(self.galleryLabel)
        self.contentViewContainer.addSubview(self.galleryCollectionView)
        
        self.descriptionContainerView.addSubview(self.descriptionLabel)
        self.descriptionContainerView.addSubview(self.movieRuntimeLabel)
        self.descriptionContainerView.addSubview(self.descriptionTextLabel)
    }
    
    override func updateViewConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentViewContainer.snp.makeConstraints { (make) in
            make.edges.equalTo(self.scrollView)
            make.width.equalTo(self.view.snp.width)
        }
        
        self.movieCellView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(self.offsets.top)
        }
        
        self.moviePlayer.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(self.offsets.left)
            make.right.equalToSuperview().inset(self.offsets)
            make.top.equalTo(self.movieCellView.snp.bottom).offset(18)
            make.height.equalTo(180)
        }
        
        self.loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.moviePlayer.snp.center)
        }
        
        self.descriptionContainerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(self.offsets.left)
            make.right.equalToSuperview().inset(self.offsets)
            make.top.equalTo(self.moviePlayer.snp.bottom).offset(24)
        }
        
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.movieRuntimeLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(self.offsets.top)
        }
        
        self.descriptionTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.movieRuntimeLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.showAllView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.descriptionContainerView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(self.offsets.left)
            make.right.equalToSuperview().inset(26)
        }
        
        self.castCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.showAllView.snp.bottom).offset(self.offsets.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(237)
        }
        
        self.galleryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.castCollectionView.snp.bottom).offset(self.offsets.top)
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(self.offsets.left)
        }
        
        self.galleryCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.galleryLabel.snp.bottom).offset(self.offsets.top)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
        
        super.updateViewConstraints()
    }
    
    init(movie: MWMovie) {
        super.init()
        self.navigationItem.setRightBarButton(self.rightBarButtonDidFavoriteItem, animated: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(memberImageUpdated),
                                               name: .memberImageUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movieImagesCollectionUpdated),
                                               name: .movieImagesCollectionUpdated, object: nil)
        self.movie = movie
        self.movieCellView.setView(movie: movie)
        
        self.fetchIsFavorite()
        
        self.loadMovieVideos()
        self.loadMovieCast()
        self.loadMovieAdditionalInfo()
        self.loadMovieImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showLoadedVideo(videoUrlKey: String?) {
        guard let key = videoUrlKey else { return }
        let videoUrl = "https://www.youtube.com/watch?v=\(key)"
        let encodedURL = videoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: encodedURL) {
            self.moviePlayer.loadVideoURL(url)
        }
    }
    
    private func loadMovieVideos() {
        guard let movieId = self.movie.id else { return }
        let urlPath = "movie/\(movieId)/videos"
        
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (videos: MWMovieVideoResponse)  in
                            guard let self = self else { return }
                            for video in videos.results {
                                if video.site == "YouTube"{
                                    guard let url = video.key else { return }
                                    self.gallery.videos.append(url)
                                }
                            }
                            self.showLoadedVideo(videoUrlKey: self.gallery.videos.first)
                            self.reloadGalleryItems()
                            self.loadingIndicator.stopAnimating()
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            
                            let message = error.getErrorDesription()
                            self.loadingIndicator.stopAnimating()
                            self.errorAlert(message: message)
        })
    }
    
    private func loadMovieCast() {
        guard let movieId = self.movie.id else { return }
        let urlPath = "movie/\(movieId)/credits"
        
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
    
    private func setCast(cast: MWMovieCastResponse) {
        self.movieFullCast = cast
        
        let sortedCast = cast.cast.sorted { (member1, member2: MWMovieCastMember) in
            guard let order1 = member1.order, let order2 = member2.order else { return false }
            return order1 < order2
        }
        self.movieFullCast?.cast = sortedCast
        
        guard let castMembers = self.movieFullCast?.cast,
            let crewMembers = self.movieFullCast?.crew else { return }
        self.setImages(to: castMembers)
        self.setImages(to: crewMembers)
    }
    
    private func loadMovieAdditionalInfo() {
        guard let movieId = self.movie.id else { return }
        let urlPath = "movie/\(movieId)"
        
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
        guard let movieId = self.movie.id else { return }
        let urlPath = "movie/\(movieId)/images"
        
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
    
    private func setImages<T>(to peoples: [T]) {
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
    
    private func setDetails() {
        self.descriptionTextLabel.text = self.movieDetails?.overview ?? ""
        guard let movieRuntime = self.movieDetails?.runtime else { return }
        self.movieRuntimeLabel.text = "\(movieRuntime) minutes"
    }
    
    private func reloadGalleryItems() {
        self.galleryItems = self.gallery.getGalleryItems()
        self.galleryCollectionView.reloadData()
    }
    
    @objc private func memberImageUpdated() {
        self.castCollectionView.reloadData()
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
    
    @objc private func didFavoriteButtonTapped() {
        self.isFavorite = !self.isFavorite
        if self.isFavorite {
            self.save()
        } else {
            self.remove()
        }
    }
}

extension MWSingelMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == galleryCollectionView {
            return self.galleryItems.count
        }
        
        guard let movieCastCount = self.movieFullCast?.cast.count, movieCastCount >= 10
            else {
                return self.movieFullCast?.cast.count ?? 0
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == galleryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.singleMovieGalleryCollectionViewCellId,
                for: indexPath) as? MWMovieGalleryCollectionViewCell else { fatalError("The registered type for the cell does not match the casting") }
            
            cell.set(galleryItem: self.galleryItems[indexPath.item])
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.singleCastMemberCollectionViewCellId,
            for: indexPath) as? MWCastMemberCollectionViewCell else { fatalError("The registered type for the cell does not match the casting") }
        
        if let memberOfCast = self.movieFullCast?.cast[indexPath.item] {
            cell.set(actor: memberOfCast)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MWI.s.pushVC(MWMemberViewController(member: self.movieFullCast?.cast[indexPath.item]))
    }
}

//MARK: CoreData Additional movie Info
extension MWSingelMovieViewController {
    private func fetchMovie() {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY id = %i and title = %@",
                                      self.movie.id ?? 0,
                                      self.movie.title ?? "")
        do {
            self.cdMovie = try managedContext.fetch(fetch).last
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @discardableResult  private func fetchAdditionalInfo() -> MovieAdditionalInfo? {
        self.fetchMovie()
        return self.cdMovie?.additionalInfo
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
            self.cdMovie?.additionalInfo = newAdditionalInfo
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
        var newInfo = MWMovieAdditionalInfo()
        guard let fetchedInfo = self.fetchAdditionalInfo() else { return }
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
extension MWSingelMovieViewController {
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @discardableResult private func fetchFavoriteMovie() -> Movie? {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        
        guard let id = self.movie.id,
            let title = self.movie.title,
            let releaseDate = self.movie.releaseDate else { return Movie() }
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
        newMovie.id = Int64(self.movie.id ?? 0)
        newMovie.posterPath = self.movie.posterPath
        newMovie.genreIds = self.movie.genreIds
        newMovie.title = self.movie.title
        newMovie.originalLanguage = self.movie.originalLanguage
        newMovie.releaseDate = self.movie.releaseDate
        
        if let movieRating = self.movie.voteAvarage {
            newMovie.voteAvarage = movieRating
        }
        
        if let imageData = self.movie.image {
            newMovie.movieImage = imageData
        }
        
        favoriteMovies.addToMovies(newMovie)
        
        self.saveContext(context: managedContext)
    }
    
    private func remove() {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        
        let favoriteMovies = FavoriteMovies(context: managedContext)
        guard let movieToRemove = self.fetchFavoriteMovie() else { return }
        favoriteMovies.removeFromMovies(movieToRemove)
        movieToRemove.favorite = nil
        
        self.saveContext(context: managedContext)
    }
}
