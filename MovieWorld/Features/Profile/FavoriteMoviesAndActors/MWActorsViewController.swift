//
//  ActorsViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/14/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import CoreData

class MWActorsViewController: MWViewController {
    
    private var cast: [[MWMovieCastMember]] = []
    
    private lazy var actorsController: MWCastViewController = {
        return MWCastViewController(castMembers: self.cast)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.actorsController.updateTableView(cast: self.getFavoriteActors())
    }
    
    init(title: String) {
        super.init()
        self.title = title
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        guard let actorsControllerView = self.actorsController.view else { return }
        
        self.contentView.addSubview(actorsControllerView)
        actorsControllerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
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
