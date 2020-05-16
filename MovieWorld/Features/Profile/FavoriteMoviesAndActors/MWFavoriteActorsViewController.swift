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

    //MARK:- gui variables

    private lazy var actorsController = MWCastViewController(castMembers: self.cast)

    private lazy var emptyListLabel = MWEmptyListLabel()

    //MARK: - initialization

    override func initController() {
        super.initController()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateTableView),
                                               name: .actorIsFavoriteChanged, object: nil)
        self.addSubviews()
        self.makeConstraints()
        self.updateTableView()
    }

    // MARK: - constraints

    private func addSubviews() {
        self.add(self.actorsController)
        self.contentView.addSubview(self.emptyListLabel)
    }

    private func makeConstraints() {
        self.actorsController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.emptyListLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    //MARK: - action if favorites list is empty

    private func setUpVisibleOfEmptyListLabel(listIsEmpty: Bool) {
        self.emptyListLabel.isHidden = !listIsEmpty
    }

    //MARK: - getter

    private func getFavoriteActors() -> [[MWMovieCastMember]]{
        let actors = MWCDHelp.sh.fetchFavoriteActors()
        self.setUpVisibleOfEmptyListLabel(listIsEmpty: actors.isEmpty)

        var mwMembers: [MWMovieCastMember] = []
        for actor in actors {
            let newMemmber = MWMovieCastMember()
            newMemmber.id = Int(actor.id )
            newMemmber.profilePath = actor.profilePath
            newMemmber.character = actor.character
            newMemmber.order = Int(actor.order )
            newMemmber.name = actor.name

            if let imageData = actor.image {
                newMemmber.image = imageData
            }

            mwMembers.append(newMemmber)
        }
        return [mwMembers]
    }

    //MARK: - Update TableView action

    @objc private func updateTableView() {
        self.actorsController.updateTableView(cast: self.getFavoriteActors())
    }
}
