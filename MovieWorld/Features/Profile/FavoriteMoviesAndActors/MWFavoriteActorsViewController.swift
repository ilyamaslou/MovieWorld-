//
//  ActorsViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/14/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import CoreData

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
        self.add(self.actorsController)
        self.contentView.addSubview(self.emptyListLabel)
        self.makeConstraints()
        self.updateTableView()
    }

    // MARK: - constraints

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

    //MARK: - Update TableView action

    @objc private func updateTableView() {
        self.actorsController.updateTableView(cast: self.getFavoriteActors())
    }
}

//MARK: - CoreData FavoriteActors

extension MWFavoriteActorsViewController {
    @discardableResult private func fetchFavoriteActors() -> [CastMember] {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<CastMember> = CastMember.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY favoriteActors != nil")

        var result: [CastMember] = []
        do {
            result = try managedContext.fetch(fetch)
        } catch {
            print(error.localizedDescription)
        }

        self.setUpVisibleOfEmptyListLabel(listIsEmpty: result.isEmpty)
        return result
    }

    private func getFavoriteActors() -> [[MWMovieCastMember]]{
        let actors = self.fetchFavoriteActors()
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
}
