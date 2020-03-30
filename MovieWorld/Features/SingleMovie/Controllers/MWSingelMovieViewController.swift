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
    
    private var movie: MWMovie = MWMovie() {
        didSet {
            self.castCollectionView.reloadData()
        }
    }
    
    private var movieFullCast: MWMovieCastResponse? {
        didSet {
            self.castCollectionView.reloadData()
        }
    }
    
    private var addittionalMovieInfo: MovieAdditionalInfo?
    private var movieDetails: MWMovieAdditionalInfo?
    private var movieImages: [Data] = []
    private var imagesResponse: MWMovieImagesResponse?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var contentViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieCellView: MWSingleMovieCellView = MWSingleMovieCellView()
    private lazy var moviePlayer: YouTubePlayerView = YouTubePlayerView()
    
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
        label.text = " Description"
        label.font = .systemFont(ofSize: 17,  weight: .bold)
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 17)
        return textView
    }()
    
    private lazy var buttonAndLabelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var labelOfCast: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cast"
        label.font = .systemFont(ofSize: 17,  weight: .bold)
        return label
    }()
    
    private lazy var showAllButton: MWCustomButton = {
        let button = MWCustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showAllButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var castCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
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
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 16
        collectionViewLayout.minimumInteritemSpacing = 16
        collectionViewLayout.sectionInset = UIEdgeInsets(top: .zero, left: self.offsets.left, bottom: .zero, right: self.offsets.right)
        collectionViewLayout.itemSize = CGSize(width: 130, height: 237)
        return collectionViewLayout
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Trailers and gallery"
        label.font = .systemFont(ofSize: 17,  weight: .bold)
        return label
    }()
    
    override func initController() {
        super.initController()
        
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(contentViewContainer)
        
        self.contentViewContainer.addSubview(self.movieCellView)
        self.contentViewContainer.addSubview(self.moviePlayer)
        self.contentViewContainer.addSubview(self.descriptionContainerView)
        self.contentViewContainer.addSubview(self.buttonAndLabelContainerView)
        self.contentViewContainer.addSubview(self.castCollectionView)
        self.contentViewContainer.addSubview(self.bottomLabel)
        
        self.descriptionContainerView.addSubview(self.descriptionLabel)
        self.descriptionContainerView.addSubview(self.movieRuntimeLabel)
        self.descriptionContainerView.addSubview(self.descriptionTextView)
        
        self.buttonAndLabelContainerView.addSubview(self.labelOfCast)
        self.buttonAndLabelContainerView.addSubview(self.showAllButton)
        
        
    }
    
    override func updateViewConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentViewContainer.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.scrollView)
            make.left.right.equalTo(self.contentView)
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
            //TODO: change this later
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
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(16)
        }
        
        self.descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.movieRuntimeLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.buttonAndLabelContainerView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.descriptionContainerView.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
        
        self.labelOfCast.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(self.offsets.left)
        }
        
        self.showAllButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.greaterThanOrEqualTo(self.labelOfCast.snp.right)
            make.right.equalToSuperview().inset(26)
        }
        
        self.castCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonAndLabelContainerView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            //TODO: change this later
            make.height.equalTo(237)
        }
        
        self.bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.castCollectionView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
    
    init(movie: MWMovie) {
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(memberImageUpdated),
                                               name: .memberImageUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movieImagesCollectionUpdated),
                                               name: .movieImagesCollectionUpdated, object: nil)
        self.movie = movie
        self.movieCellView.setView(movie: movie)
        
        self.loadMovieVideo()
        self.loadMovieCast()
        self.loadMovieAdditionalInfo()
        self.loadMovieImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //TODO: Not every time recieved videoPath -> hide player or check for teaser
    private func showLoadedVideo(videoUrlKey: String?) {
        guard let key = videoUrlKey else { return }
        let videoUrl = "https://www.youtube.com/watch?v=\(key)"
        let encodedURL = videoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: encodedURL) {
            moviePlayer.loadVideoURL(url)
        }
    }
    
    private func loadMovieVideo() {
        guard let movieId = self.movie.id else { return }
        let urlPath = "movie/\(movieId)/videos"
        
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (videos: MWMovieVideoResponse)  in
                            guard let self = self else { return }
                            for video in videos.results {
                                if video.site == "YouTube"{
                                    self.showLoadedVideo(videoUrlKey: video.key)
                                }
                                break
                            }
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
    }
    
    private func loadMovieCast() {
        guard let movieId = self.movie.id else { return }
        let urlPath = "movie/\(movieId)/credits"
        
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (cast: MWMovieCastResponse)  in
                            guard let self = self else { return }
                            
                            self.movieFullCast = cast
                            guard let castMembers = self.movieFullCast?.cast,
                                let crewMembers = self.movieFullCast?.crew else { return }
                            self.setImages(to: castMembers)
                            self.setImages(to: crewMembers)
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            
                            let message = error.getErrorDesription()
                            self.errorAlert(message: message)
        })
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
        self.descriptionTextView.text = self.movieDetails?.overview ?? ""
        guard let movieRuntime = self.movieDetails?.runtime else { return }
        self.movieRuntimeLabel.text = " \(movieRuntime) minutes"
    }
    
    @objc private func memberImageUpdated() {
        self.castCollectionView.reloadData()
    }
    
    @objc private func movieImagesCollectionUpdated() {
        guard let response = self.imagesResponse?.movieImages else { return }
        self.movieImages = response
    }
    
    @objc private func showAllButtonDidTapped() {
        //           MWI.s.pushVC()
    }
}

extension MWSingelMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movieCastCount = self.movieFullCast?.cast.count, movieCastCount >= 10
            else {
                return self.movieFullCast?.cast.count ?? 0
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.singleCastMemberCollectionViewCellId,
            for: indexPath) as? MWCastMemberCollectionViewCell else { fatalError("The registered type for the cell does not match the casting") }
        
        if let memberOfCast = self.movieFullCast?.cast[indexPath.item] {
            cell.set(actor: memberOfCast)
        }
        
        return cell
    }
}

extension MWSingelMovieViewController {
    @discardableResult  private func fetchAdditionalInfo() -> MovieAdditionalInfo? {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<MovieAdditionalInfo> = MovieAdditionalInfo.fetchRequest()
        
        var additionalInfo: MovieAdditionalInfo?
        do {
            additionalInfo = try managedContext.fetch(fetch).last
        } catch {
            print(error.localizedDescription)
        }
        
        return additionalInfo
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
