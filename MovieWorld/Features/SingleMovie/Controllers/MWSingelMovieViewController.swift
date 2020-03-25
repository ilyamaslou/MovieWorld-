//
//  MWSingelMovieViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import YouTubePlayer

class MWSingelMovieViewController: MWViewController {
    
    private var movie: MWMovie = MWMovie() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var movieFullCast: MWMovieCastResponse? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var movieDetails: MWMovieDetails?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var moviePlayer: YouTubePlayerView = YouTubePlayerView()
    
    private lazy var descriptionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var descriptioContentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var isAdultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15,  weight: .light)
        return label
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
    
    private lazy var collectionView: UICollectionView = {
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
        collectionViewLayout.minimumLineSpacing = 8
        collectionViewLayout.minimumInteritemSpacing = 16
        collectionViewLayout.sectionInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
        return collectionViewLayout
    }()
    
    override func initController() {
        super.initController()
        
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(contentViewContainer)
        
        self.contentViewContainer.addSubview(self.moviePlayer)
        self.contentViewContainer.addSubview(self.descriptionContainerView)
        self.contentViewContainer.addSubview(self.buttonAndLabelContainerView)
        self.contentViewContainer.addSubview(self.collectionView)
        
        self.descriptionContainerView.addSubview(self.descriptionLabel)
        self.descriptionContainerView.addSubview(self.descriptioContentContainerView)
        self.descriptionContainerView.addSubview(self.descriptionTextView)
        
        self.descriptioContentContainerView.addSubview(self.isAdultLabel)
        self.descriptioContentContainerView.addSubview(self.movieRuntimeLabel)
        
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
        
        self.moviePlayer.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            //TODO: change this later
            make.height.equalTo(300)
        }
        
        self.descriptionContainerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(self.moviePlayer.snp.bottom).offset(24)
        }
        
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.descriptioContentContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(16)
            make.bottom.equalTo(self.descriptionTextView.snp.top).offset(-8)
            make.left.right.equalToSuperview()
            
        }
        
        self.isAdultLabel.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview()
            make.right.equalTo(self.movieRuntimeLabel.snp.left)
        }
        
        self.movieRuntimeLabel.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
        }
        
        self.descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptioContentContainerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.buttonAndLabelContainerView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.descriptionContainerView.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
        
        self.labelOfCast.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        self.showAllButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.greaterThanOrEqualTo(self.labelOfCast.snp.right)
            make.right.equalToSuperview().offset(-26)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonAndLabelContainerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            //TODO: change this later
            make.height.equalTo(300)
        }
        
        super.updateViewConstraints()
    }
    
    init(movie: MWMovie) {
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(memberImageUpdated),
                                               name: .memberImageUpdated, object: nil)
        
        self.movie = movie
        self.loadMovieVideo()
        self.loadMovieCast()
        self.loadMovieDescription()
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
                                if video.type == "Trailer" && video.site == "YouTube"{
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
    
    private func loadMovieDescription() {
        guard let movieId = self.movie.id else { return }
        let urlPath = "movie/\(movieId)"
        
        MWNet.sh.request(urlPath: urlPath ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (details: MWMovieDetails)  in
                            guard let self = self else { return }
                            self.movieDetails = details
                            self.setDetails()
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
        self.isAdultLabel.text = (self.movieDetails?.adult ?? false) ? " 18+" : ""
        guard let movieRuntime = self.movieDetails?.runtime else { return }
        self.movieRuntimeLabel.text = " \(movieRuntime) minutes"
    }
    
    @objc private func memberImageUpdated() {
        self.collectionView.reloadData()
    }
    
    @objc private func showAllButtonDidTapped() {
        //           MWI.s.pushVC()
    }
}

extension MWSingelMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieFullCast?.cast.count ?? 0
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 237)
    }
}
