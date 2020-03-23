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
    
    private var movie: MWMovie = MWMovie()
    
    private lazy var moviePlayer: YouTubePlayerView = YouTubePlayerView()
    
    override func initController() {
        super.initController()
        
        self.contentView.addSubview(moviePlayer)
        
        self.moviePlayer.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(350)
        }
    }
    
    init(movie: MWMovie) {
        super.init()
        self.movie = movie
        self.loadMovieVideo(for: self.movie)
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
    
}
