//
//  MWInitController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import CoreData

class MWInitController: MWViewController {
    
    private var genres: [MWGenre] = []
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(named: "accentColor")
        
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            indicator.style = .whiteLarge
        }
        
        return indicator
    }()
    
    private lazy var group = DispatchGroup()
    
    override func initController() {
        super.initController()
        
        contentView.addSubview(self.loadingIndicator)
        
        self.loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.loadingIndicator.startAnimating()
        
        self.fetchGenres()
        self.loadGenres()
        self.loadConfiguration()
        
        self.group.notify(queue: .main, execute: MWI.s.setUpTabBar)
    }
    
    private func loadGenres() {
        self.group.enter()
        MWNet.sh.request(urlPath: URLPaths.getGenres ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (genres: MWGenreResponse)  in
                            guard let self = self else { return }
                            self.save(genres: genres.genres)
                            MWSys.sh.genres = self.genres
                            
                            self.group.leave()
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            print(message)
                            
                            self.fetchGenres()
                            MWSys.sh.genres = self.genres
                            
                            self.group.leave()
        })
    }
    
    private func loadConfiguration() {
        self.group.enter()
        MWNet.sh.request(urlPath: URLPaths.getConfiguration ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (configuration: MWConfiguration)  in
                            guard let self = self else { return }
                            MWSys.sh.configuration = configuration
                            self.group.leave()
                            
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            print(message)
                            self.group.leave()
        })
    }
    
    private func fetchGenres() {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<Genre> = Genre.fetchRequest()
        do {
            let genres = try managedContext.fetch(fetch)
            
            for genre in genres {
                let mwGenre = MWGenre(id: Int(genre.id), name: genre.name)
                self.genres.append(mwGenre)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func save (genres: [MWGenre]) {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        
        for genre in genres {
            let newGenre = Genre(context: managedContext)
            newGenre.id = Int32(genre.id)
            newGenre.name = genre.name
        }
        
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        self.fetchGenres()
    }
}
