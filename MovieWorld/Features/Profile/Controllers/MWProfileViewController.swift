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
        button.setTitle("Favorites", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(favoriteButtonDidPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func initController() {
        super.initController()
        self.title = "Profile"

        let view = UIView()
        self.contentView.addSubview(view)
        view.addSubview(self.favoriteMovies)

        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.favoriteMovies.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    @objc private func favoriteButtonDidPressed() {
        MWI.s.pushVC(MasterFavoriteViewController())
    }
}
