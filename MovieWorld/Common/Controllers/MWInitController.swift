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
    private var imageConfiguration: MWImageConfiguration = MWImageConfiguration()
    
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
        self.fetchImageConfiguration()
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
                            self.saveGenres(genres: genres.genres)
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
                            self.saveImageConfiguration(imageConfiguration: configuration.images ?? MWImageConfiguration())
                            MWSys.sh.configuration = MWConfiguration(images: self.imageConfiguration)
                            
                            self.group.leave()
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = error.getErrorDesription()
                            print(message)
                            
                            self.fetchImageConfiguration()
                            MWSys.sh.configuration = MWConfiguration(images: self.imageConfiguration)
                            
                            self.group.leave()
        })
    }
}

//MARK: CoreData actions
extension MWInitController {
    
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
    
    private func fetchImageConfiguration() {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<ImageConfiguration> = ImageConfiguration.fetchRequest()
        do {
            let imageConfiguration = try managedContext.fetch(fetch).last
            
            self.imageConfiguration = MWImageConfiguration(
                baseUrl: imageConfiguration?.baseUrl,
                secureBaseUrl: imageConfiguration?.secureBaseUrl,
                backdropSizes: imageConfiguration?.backdropSizes,
                logoSizes: imageConfiguration?.logoSizes,
                posterSizes: imageConfiguration?.posterSizes,
                profileSizes: imageConfiguration?.profileSizes,
                stillSizes: imageConfiguration?.stillSizes)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveGenres (genres: [MWGenre]) {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        
        for genre in genres {
            let newGenre = Genre(context: managedContext)
            newGenre.id = Int64(genre.id)
            newGenre.name = genre.name
        }
        
        self.save(managedContext: managedContext)
        self.fetchGenres()
    }
    
    private func saveImageConfiguration (imageConfiguration: MWImageConfiguration) {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        
        let newConfiguration = ImageConfiguration(context: managedContext)
        newConfiguration.baseUrl = imageConfiguration.baseUrl
        newConfiguration.secureBaseUrl = imageConfiguration.secureBaseUrl
        newConfiguration.backdropSizes = imageConfiguration.backdropSizes
        newConfiguration.logoSizes = imageConfiguration.logoSizes
        newConfiguration.posterSizes = imageConfiguration.posterSizes
        newConfiguration.profileSizes = imageConfiguration.profileSizes
        newConfiguration.stillSizes = imageConfiguration.stillSizes
        
        self.save(managedContext: managedContext)
        self.fetchGenres()
    }
    
    private func save (managedContext: NSManagedObjectContext) {
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
