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

    private func fetchMovie(withPredicate predicate: NSPredicate? = nil) -> Movie? {
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

    func fetchFavoriteActor(mwMember: Personalized) -> CastMember? {
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

    func fetchFavoriteMovie(mwMovie: MWMovie?) -> Movie? {
        guard let id = mwMovie?.id,
            let title = mwMovie?.title,
            let releaseDate = mwMovie?.releaseDate else { return Movie() }

        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY id = %i and title = %@ and releaseDate = %@ and favorite != nil", id, title, releaseDate)

        var result: [Movie] = []
        do {
            result = try self.managedContext.fetch(fetch)
        } catch {
            print(error.localizedDescription)
        }

        return result.first
    }

    func fetchMovieForAdditionalInfo(for movie: MWMovie) -> Movie? {
        let predicate = NSPredicate(format: "ANY id = %i and title = %@",
                                    movie.id ?? 0,
                                    movie.title ?? "")
        return self.fetchMovie(withPredicate: predicate)
    }

    func fetchMoviesByCategory(category: MWMainCategories) -> [Movie] {
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY category.movieCategory = %@", category.rawValue)

        var result: [Movie] = []
        do {
            result = try self.managedContext.fetch(fetch)
        } catch {
            print(error.localizedDescription)
        }
        return result
    }

    func fetchFavoriteMovies() -> [Movie] {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY favorite != nil")

        var result: [Movie] = []
        do {
            result = try managedContext.fetch(fetch)
        } catch {
            print(error.localizedDescription)
        }

        return result
    }

    func fetchFavoriteActors() -> [CastMember] {
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

    //MARK: - save actions

    func saveImage(for movie: MWMovie, imageData: Data, in category: String) {
        let predicate = NSPredicate(format: "ANY title = %@ and category.movieCategory = %@", movie.title ?? "", category)
        let result = self.fetchMovie(withPredicate: predicate)
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

    private func didSaveOrUpdateImageConfiguration(cdConfiguration: ImageConfiguration, mwConfiguration: MWImageConfiguration) {
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

    func saveFavoriteMovie(mwMovie: MWMovie?) {
        let favoriteMovies = FavoriteMovies(context: self.managedContext)
        let newMovie = Movie(context: self.managedContext)
        newMovie.id = Int64(mwMovie?.id ?? 0)
        newMovie.posterPath = mwMovie?.posterPath
        newMovie.genreIds = mwMovie?.genreIds
        newMovie.title = mwMovie?.title
        newMovie.originalLanguage = mwMovie?.originalLanguage
        newMovie.releaseDate = mwMovie?.releaseDate

        if let movieRating = mwMovie?.voteAvarage {
            newMovie.voteAvarage = movieRating
        }

        if let imageData = mwMovie?.image {
            newMovie.movieImage = imageData
        }

        favoriteMovies.addToMovies(newMovie)
        self.saveContext()
    }

    func saveAdditionalInfo (info: MWMovieAdditionalInfo, forMovie: MWMovie?) {
        guard let movie = forMovie else { return }
        let coreDataMovie = self.fetchMovieForAdditionalInfo(for: movie)

        if coreDataMovie?.additionalInfo == nil {
            let newAdditionalInfo = MovieAdditionalInfo(context: managedContext)
            newAdditionalInfo.adult = info.adult ?? false
            newAdditionalInfo.overview = info.overview
            newAdditionalInfo.runtime = Int64(info.runtime ?? 0)
            newAdditionalInfo.tagline = info.tagline
            coreDataMovie?.additionalInfo = newAdditionalInfo
        } else {
            guard let fetchedInfo = coreDataMovie?.additionalInfo else { return }
            fetchedInfo.adult = info.adult ?? false
            fetchedInfo.overview = info.overview
            fetchedInfo.runtime = Int64(info.runtime ?? 0)
            fetchedInfo.tagline = info.tagline
        }
        self.saveContext()
    }

    func saveMoviesInCategory(mwCategory: MWMainCategories, movies: [MWMovie]) {
        let result = self.fetchMoviesByCategory(category: mwCategory)
        if result.isEmpty {
            let category = MovieCategory(context: self.managedContext)
            category.movieCategory = mwCategory.rawValue

            for movie in movies {
                let newMovie = Movie(context: self.managedContext)
                newMovie.id = Int64(movie.id ?? 0)
                newMovie.posterPath = movie.posterPath
                newMovie.genreIds = movie.genreIds
                newMovie.title = movie.title
                newMovie.originalLanguage = movie.originalLanguage
                newMovie.releaseDate = movie.releaseDate
                if let movieRating = movie.voteAvarage {
                    newMovie.voteAvarage = movieRating
                }
                category.addToMovies(newMovie)
            }
        } else {
            for (id, movie) in movies.enumerated() {
                let movieToUpdate = result[id]
                movieToUpdate.id = Int64(movie.id ?? 0)
                movieToUpdate.posterPath = movie.posterPath
                movieToUpdate.genreIds = movie.genreIds
                movieToUpdate.title = movie.title
                movieToUpdate.originalLanguage = movie.originalLanguage
                movieToUpdate.releaseDate = movie.releaseDate
                guard let movieRating = movie.voteAvarage else { return }
                movieToUpdate.voteAvarage = movieRating
            }
        }
        self.saveContext()
    }

    private func saveContext(managedContext: NSManagedObjectContext = CoreDataManager.s.persistentContainer.viewContext) {
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    //MARK: - remove actions

    func removeFavoriteActor(mwMember: Personalized) {
        guard let memberToRemove = self.fetchFavoriteActor(mwMember: mwMember) else { return }
        let favoriteActors = FavoriteActors(context: self.managedContext)

        favoriteActors.removeFromActors(memberToRemove)
        memberToRemove.favoriteActors = nil
        self.saveContext()
    }

    func removeFavoriteMovie(mwMovie: MWMovie?) {
        guard let movieToRemove = self.fetchFavoriteMovie(mwMovie: mwMovie) else { return }
        let favoriteMovies = FavoriteMovies(context: self.managedContext)
        favoriteMovies.removeFromMovies(movieToRemove)
        movieToRemove.favorite = nil
        self.saveContext()
    }
}
