//
//  MWCoreDataHelper.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/16/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation
import CoreData
typealias MWCDHelp = MWCoreDataHelper

class MWCoreDataHelper {

    //MARK: - static variables

    static let sh = MWCoreDataHelper()

    //MARK: - private variable

    private let managedContext = CoreDataManager.s.persistentContainer.viewContext
    //MARK: - initialization

    private init() {}

    //MARK: - fetch actions

    func fetchMovie(for movie: MWMovie, in category: String, withPredicate predicate: NSPredicate? = nil) -> Movie? {
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        if let predicate = predicate {
            fetch.predicate = predicate
        }

        var movie: Movie?
        do {
            movie = try self.managedContext.fetch(fetch).first
        } catch {
            print(error.localizedDescription)
        }
        return movie
    }

    func fetchImageConfiguration() -> (coreDataConfiguration: ImageConfiguration?, mwConfiguration: MWImageConfiguration) {
        let fetch: NSFetchRequest<ImageConfiguration> = ImageConfiguration.fetchRequest()
        var configuration: ImageConfiguration? = ImageConfiguration()
        var imageConfiguration = MWImageConfiguration()
        do {
            configuration = try self.managedContext.fetch(fetch).last

            imageConfiguration = MWImageConfiguration(
                baseUrl: configuration?.baseUrl,
                secureBaseUrl: configuration?.secureBaseUrl,
                backdropSizes: configuration?.backdropSizes,
                logoSizes: configuration?.logoSizes,
                posterSizes: configuration?.posterSizes,
                profileSizes: configuration?.profileSizes,
                stillSizes: configuration?.stillSizes)
        } catch {
            print(error.localizedDescription)
        }

        return (configuration, imageConfiguration)
    }

    func fetchGenres() -> (coreDataGenres: [Genre], mwGenres: [MWGenre]) {
        var mwGenres: [MWGenre] = []
        var genres: [Genre] = []

        let fetch: NSFetchRequest<Genre> = Genre.fetchRequest()
        do {
            genres = try self.managedContext.fetch(fetch)
            for genre in genres {
                let mwGenre = MWGenre(id: Int(genre.id), name: genre.name ?? "")
                mwGenres.append(mwGenre)
            }
        } catch {
            print(error.localizedDescription)
        }

        return (genres, mwGenres)
    }

    //MARK: - save actions

    func saveImage(for movie: MWMovie, imageData: Data, in category: String) {
        let predicate = NSPredicate(format: "ANY title = %@ and category.movieCategory = %@", movie.title ?? "", category)
        let result = self.fetchMovie(for: movie, in: category, withPredicate: predicate)
        result?.movieImage = imageData
        self.saveContext()
    }

    func saveImageConfiguration (imageConfiguration: MWImageConfiguration) {
        let fetchedImageConfiguration = self.fetchImageConfiguration().coreDataConfiguration

        if fetchedImageConfiguration == nil {
            let newConfiguration = ImageConfiguration(context: self.managedContext)
            self.didSaveOrUpdateImageConfiguration(cdConfiguration: newConfiguration, mwConfiguration: imageConfiguration)

        } else {
            guard let configuration = fetchedImageConfiguration else { return }
            self.didSaveOrUpdateImageConfiguration(cdConfiguration: configuration, mwConfiguration: imageConfiguration)
        }
    }

    func didSaveOrUpdateImageConfiguration(cdConfiguration: ImageConfiguration, mwConfiguration: MWImageConfiguration) {
        cdConfiguration.baseUrl = mwConfiguration.baseUrl
        cdConfiguration.secureBaseUrl = mwConfiguration.secureBaseUrl
        cdConfiguration.backdropSizes = mwConfiguration.backdropSizes
        cdConfiguration.logoSizes = mwConfiguration.logoSizes
        cdConfiguration.posterSizes = mwConfiguration.posterSizes
        cdConfiguration.profileSizes = mwConfiguration.profileSizes
        cdConfiguration.stillSizes = mwConfiguration.stillSizes

        guard let context = cdConfiguration.managedObjectContext  else { return }
        self.saveContext(managedContext: context)
    }

    func saveGenres (genres: [MWGenre]) {
        let fetchedGenres = self.fetchGenres().coreDataGenres

        if fetchedGenres.isEmpty {
            for genre in genres {
                let newGenre = Genre(context: self.managedContext)
                newGenre.id = Int64(genre.id)
                newGenre.name = genre.name
            }
        } else {
            for (id, genre) in genres.enumerated() {
                fetchedGenres[id].id = Int64(genre.id)
                fetchedGenres[id].name = genre.name
            }
        }
        self.saveContext()
    }

    func saveContext(managedContext: NSManagedObjectContext = CoreDataManager.s.persistentContainer.viewContext) {
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    @discardableResult func fetchFavoriteActor(mwMember: Personalized) -> CastMember? {
        guard let member = mwMember as? MWMovieCastMember,
            let id = member.id,
            let name = member.name else { return CastMember() }

        let fetch: NSFetchRequest<CastMember> = CastMember.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY id = %i and name = %@ and favoriteActors != nil", id, name)

        var result: [CastMember] = []
        do {
            result = try self.managedContext.fetch(fetch)
        } catch {
            print(error.localizedDescription)
        }

        return result.first
    }

    func saveFavoriteActor(mwMember: Personalized) {
        guard let member = mwMember as? MWMovieCastMember else { return }
        let favoriteActors = FavoriteActors(context: self.managedContext)
        let newMemmber = CastMember(context: self.managedContext)

        newMemmber.id = Int64(member.id ?? 0)
        newMemmber.profilePath = member.profilePath
        newMemmber.character = member.character
        newMemmber.order = Int64(member.order ?? 0)
        newMemmber.name = member.name

        if let imageData = member.image {
            newMemmber.image = imageData
        }

        favoriteActors.addToActors(newMemmber)

        self.saveContext()
    }

    func removeFavoriteActor(mwMember: Personalized) {
        guard let memberToRemove = self.fetchFavoriteActor(mwMember: mwMember) else { return }
        let favoriteActors = FavoriteActors(context: self.managedContext)

        favoriteActors.removeFromActors(memberToRemove)
        memberToRemove.favoriteActors = nil
        self.saveContext()
    }
}
