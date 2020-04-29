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

    private var cast: [[MWMovieCastMember]] = []

    private lazy var actorsController: MWCastViewController = {
        return MWCastViewController(castMembers: self.cast)
    }()

    private lazy var emptyListLabel: UILabel = {
        let label = UILabel()
        label.text = "The favorites peoples list is empty"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.isHidden = true
        return label
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.actorsController.updateTableView(cast: self.getFavoriteActors())
    }

    override func initController() {
        super.initController()
        self.setUpView()
    }

    private func setUpView() {
        guard let actorsControllerView = self.actorsController.view else { return }
        self.contentView.addSubview(actorsControllerView)
        self.contentView.addSubview(self.emptyListLabel)

        actorsControllerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.emptyListLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    private func setUpVisibleOfEmptyListLabel(listIsEmpty: Bool) {
        self.emptyListLabel.isHidden = listIsEmpty ? false : true
    }
}

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
