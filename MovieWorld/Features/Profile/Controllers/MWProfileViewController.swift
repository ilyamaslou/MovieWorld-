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

    //MARK:- gui variable

    private lazy var favoriteMovies: UIButton = {
        var button = UIButton()
        button.setTitle("Favorites", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.favoriteButtonDidPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //MARK: - initialization

    override func initController() {
        super.initController()
        self.title = "Profile"
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.contentView.addSubview(self.favoriteMovies)

        self.favoriteMovies.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    //MARK: - tap action

    @objc private func favoriteButtonDidPressed() {
        MWI.s.pushVC(MWMasterFavoriteViewController())
    }
}
