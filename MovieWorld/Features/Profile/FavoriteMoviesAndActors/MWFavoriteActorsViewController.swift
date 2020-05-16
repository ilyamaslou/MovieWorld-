//
//  ActorsViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/14/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWFavoriteActorsViewController: MWViewController {

    //MARK: - private variable

    private var cast: [[MWMovieCastMember]] = []

    //MARK:- gui variable

    private lazy var actorsController = MWCastViewController(castMembers: self.cast)

    //MARK: - initialization

    override func initController() {
        super.initController()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateTableView),
                                               name: .actorIsFavoriteChanged, object: nil)
        self.setUpView()
        self.updateTableView()
    }

    // MARK: - constraints

    private func setUpView() {
        self.add(self.actorsController)
        self.actorsController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    //MARK: - Update TableView action

    @objc private func updateTableView() {
        self.actorsController.updateTableView(cast: MWCDHelp.sh.fetchFavoriteActors())
    }
}
