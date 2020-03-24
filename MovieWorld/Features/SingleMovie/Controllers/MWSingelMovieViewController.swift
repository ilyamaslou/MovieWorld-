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
    
    private lazy var moviePlayer: YouTubePlayerView = YouTubePlayerView()
    
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
        
        self.contentView.addSubview(self.moviePlayer)
        self.contentView.addSubview(self.collectionView)
        
        self.moviePlayer.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            //TODO: change this later
            make.height.equalTo(200)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.moviePlayer.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    init(movie: MWMovie) {
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(memberImageUpdated),
                                               name: .memberImageUpdated, object: nil)
        
        self.movie = movie
        self.loadMovieVideo(for: self.movie)
        self.loadMovieCast(for: self.movie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showLoadedVideo(videoUrlKey: String?) {
        guard let key = videoUrlKey else { return }
        let videoUrl = "https://www.youtube.com/watch?v=\(key)"
        let encodedURL = videoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: encodedURL) {
            moviePlayer.loadVideoURL(url)
        }
    }
    
    private func loadMovieVideo(for movie: MWMovie) {
        guard let movieId = movie.id else { return }
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
    
    private func loadMovieCast(for movie: MWMovie) {
        guard let movieId = movie.id else { return }
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
    
    @objc private func memberImageUpdated() {
        self.collectionView.reloadData()
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
