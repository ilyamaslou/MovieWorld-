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

    //MARK: - static variable

    static var reuseIdentifier: String = "MWMovieGalleryCollectionViewCell"

    //MARK:- gui variables

    private lazy var movieImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()

    private lazy var movieVideoView = YouTubePlayerView()

    //MARK: - initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.contentView.addSubview(movieImageView)
        self.contentView.addSubview(movieVideoView)

        self.movieImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.movieVideoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    //MARK:- setters

    func set(galleryItem: Any) {
        if let image = galleryItem as? Data {
            self.movieImageView.image = UIImage(data: image)
            self.movieVideoView.isHidden = true
            self.movieImageView.isHidden = false
        } else if let videoUrl = galleryItem as? String {
            self.setAndShowLoadedVideo(videoUrlKey: videoUrl)
            self.movieImageView.isHidden = true
            self.movieVideoView.isHidden = false
        } else {
            return
        }
        self.setNeedsUpdateConstraints()
    }

    private func setAndShowLoadedVideo(videoUrlKey: String?) {
        guard let key = videoUrlKey else { return }
        let videoUrl = String(format: URLPaths.getVideo, key)
        let encodedURL = videoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: encodedURL) {
            self.movieVideoView.loadVideoURL(url)
        }
    }
}
