//
//  MWMovieGalleryCollectionViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/30/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import YouTubePlayer

class MWMovieGalleryCollectionViewCell: UICollectionViewCell {
    
    private lazy var movieImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieVideoView: YouTubePlayerView = YouTubePlayerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCell() {
        self.contentView.addSubview(movieImageView)
        self.contentView.addSubview(movieVideoView)
        
        self.movieImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.movieVideoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func set(galleryItem: Any) {
        
        if let image = galleryItem as? Data {
            self.movieImageView.image = UIImage(data: image)
            self.movieVideoView.isHidden = true
            self.movieImageView.isHidden = false
        } else if let videoUrl = galleryItem as? String {
            self.showLoadedVideo(videoUrlKey: videoUrl)
            self.movieImageView.isHidden = true
            self.movieVideoView.isHidden = false
        } else {
            return
        }
        
    }
    
    //TODO: Not every time recieved videoPath -> hide player or check for teaser
    private func showLoadedVideo(videoUrlKey: String?) {
        guard let key = videoUrlKey else { return }
        let videoUrl = "https://www.youtube.com/watch?v=\(key)"
        let encodedURL = videoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: encodedURL) {
            self.movieVideoView.loadVideoURL(url)
        }
    }
}
