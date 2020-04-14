//
//  ProfileViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/12/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import CoreData

class MWProfileViewController: MWViewController {
    
    private lazy var favoriteMovies: UIButton = {
        var button = UIButton()
        button.setTitle("Favorite movies", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(favoriteMoviesButtonDidPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var favoriteActors: UIButton = {
        var button = UIButton()
        button.setTitle("Favorite actors", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(favoriteActorsButtonDidPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func initController() {
        super.initController()
        self.title = "Profile"
        
        let view = UIView()
        contentView.addSubview(view)
        view.addSubview(self.favoriteMovies)
        view.addSubview(self.favoriteActors)
        
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.favoriteMovies.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.favoriteActors.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.favoriteMovies.snp.bottom).offset(10)
        }
    }
    
    @objc private func favoriteMoviesButtonDidPressed() {
        MWI.s.pushVC(MWFavoriteMoviesViewController(title: "Favorites"))
    }
    
    @objc private func favoriteActorsButtonDidPressed() {
        MWI.s.pushVC(MWActorsViewController(title: "Favorites"))
    }
}
