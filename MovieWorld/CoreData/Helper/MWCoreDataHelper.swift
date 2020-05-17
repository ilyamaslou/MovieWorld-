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
        return self.fetchItems(fetch: fetch).first
    }

    func fetchImageConfiguration() -> (coreDataConfiguration: ImageConfiguration?, mwConfiguration: MWImageConfiguration) {
        let fetch: NSFetchRequest<ImageConfiguration> = ImageConfiguration.fetchRequest()
        let configuration: ImageConfiguration? = self.fetchItems(fetch: fetch).last
        let imageConfiguration = self.convertImageConfiguration(from: configuration)
        return (configuration, imageConfiguration)
    }

    func fetchGenres() -> (coreDataGenres: [Genre], mwGenres: [MWGenre]) {
        let fetch: NSFetchRequest<Genre> = Genre.fetchRequest()
        var mwGenres: [MWGenre] = []
        let genres: [Genre] = self.fetchItems(fetch: fetch)

        for genre in genres {
            let mwGenre = MWGenre(id: Int(genre.id), name: genre.name ?? "")
            mwGenres.append(mwGenre)
        }
        return (genres, mwGenres)
    }

    func fetchFavoriteActor(mwMember: Personalized) -> CastMember? {
        guard let member = mwMember as? MWMovieCastMember,
            let id = member.id,
            let name = member.name else { return CastMember() }

        let fetch: NSFetchRequest<CastMember> = CastMember.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY id = %i and name = %@ and favoriteActors != nil", id, name)
        return self.fetchItems(fetch: fetch).first
    }

    func fetchFavoriteMovie(mwMovie: MWMovie?) -> Movie? {
        guard let id = mwMovie?.id,
            let title = mwMovie?.title,
            let releaseDate = mwMovie?.releaseDate else { return Movie() }

        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY id = %i and title = %@ and releaseDate = %@ and favorite != nil", id, title, releaseDate)
        return self.fetchItems(fetch: fetch).first
    }

    func fetchMovieForAdditionalInfo(for movie: MWMovie) -> (cdMovie: Movie?, mwInfo: MWMovieAdditionalInfo) {
        let predicate = NSPredicate(format: "ANY id = %i and title = %@",
                                    movie.id ?? 0,
                                    movie.title ?? "")
        let movie = self.fetchMovie(withPredicate: predicate)
        return (cdMovie: movie, mwInfo: self.convertAdditionalInfo(from: movie?.additionalInfo) )
    }

    func fetchMoviesByCategory(category: MWMainCategories) -> (cdMovies: [Movie], mwMovies: [MWMovie]) {
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY category.movieCategory = %@", category.rawValue)
        let movies = self.fetchItems(fetch: fetch)
        return (cdMovies: movies, mwMovies: self.convertMovies(movies: movies))
    }

    func fetchFavoriteMovies() -> [MWMovie] {
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY favorite != nil")
        return self.convertFavoriteMovies(from: self.fetchItems(fetch: fetch))
    }

    func fetchFavoriteActors() -> [[MWMovieCastMember]] {
        let fetch: NSFetchRequest<CastMember> = CastMember.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY favoriteActors != nil")
        return self.convertFavoriteActors(from: self.fetchItems(fetch: fetch))
    }

    private func fetchItems<T>(fetch: NSFetchRequest<T>) -> [T] {
        var result: [T] = []
        do {
            result = try self.managedContext.fetch(fetch)
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
            self.setMWImageConfigurationToCoreData(mwConfiguration: imageConfiguration, cdConfiguration: newConfiguration)
        } else {
            guard let configuration = fetchedImageConfiguration else { return }
            self.setMWImageConfigurationToCoreData(mwConfiguration: imageConfiguration, cdConfiguration: configuration)
        }
        self.saveContext()
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
        let favoriteActors = FavoriteActors(context: self.managedContext)
        let newMemmber = CastMember(context: self.managedContext)
        self.setMWMemberValuesToCoreDataMember(mwMember: mwMember, for: newMemmber)
        favoriteActors.addToActors(newMemmber)
        self.saveContext()
    }

    func saveFavoriteMovie(mwMovie: MWMovie?) {
        guard let mwMovie = mwMovie else { return }
        let favoriteMovies = FavoriteMovies(context: self.managedContext)
        let newMovie = Movie(context: self.managedContext)
        self.setMwMovieValuesToCoreDataMovie(mwMovie: mwMovie, for: newMovie)
        favoriteMovies.addToMovies(newMovie)
        self.saveContext()
    }

    func saveAdditionalInfo (info: MWMovieAdditionalInfo, forMovie: MWMovie?) {
        guard let movie = forMovie else { return }
        let coreDataMovie = self.fetchMovieForAdditionalInfo(for: movie).cdMovie

        if let fetchedInfo = coreDataMovie?.additionalInfo{
            self.setMWMovieAdditionalInfoToCoreDataAdditionalInfo(mwInfo: info, for: fetchedInfo)
        } else {
            let newAdditionalInfo = MovieAdditionalInfo(context: self.managedContext)
            self.setMWMovieAdditionalInfoToCoreDataAdditionalInfo(mwInfo: info, for: newAdditionalInfo)
            coreDataMovie?.additionalInfo = newAdditionalInfo
        }
        self.saveContext()
    }

    func saveMoviesInCategory(mwCategory: MWMainCategories, movies: [MWMovie]) {
        let result = self.fetchMoviesByCategory(category: mwCategory).cdMovies
        if result.isEmpty {
            let category = MovieCategory(context: self.managedContext)
            category.movieCategory = mwCategory.rawValue

            for movie in movies {
                let newMovie = Movie(context: self.managedContext)
                self.setMwMovieValuesToCoreDataMovie(mwMovie: movie, for: newMovie)
                category.addToMovies(newMovie)
            }
        } else {
            for (id, movie) in movies.enumerated() {
                let movieToUpdate = result[id]
                self.setMwMovieValuesToCoreDataMovie(mwMovie: movie, for: movieToUpdate)
            }
        }
        self.saveContext()
    }

    private func saveContext() {
        do {
            try self.managedContext.save()
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

    //MARK: - setters

    private func setMwMovieValuesToCoreDataMovie(mwMovie: MWMovie, for movie: Movie) {
        movie.id = Int64(mwMovie.id ?? 0)
        movie.posterPath = mwMovie.posterPath
        movie.genreIds = mwMovie.genreIds
        movie.title = mwMovie.title
        movie.originalLanguage = mwMovie.originalLanguage
        movie.releaseDate = mwMovie.releaseDate

        if let movieRating = mwMovie.voteAvarage {
            movie.voteAvarage = movieRating
        }

        guard let imageData = mwMovie.image else { return }
        movie.movieImage = imageData
    }

    private func setMWMemberValuesToCoreDataMember(mwMember: Personalized, for member: CastMember) {
        guard let mwMember = mwMember as? MWMovieCastMember else { return }
        member.id = Int64(mwMember.id ?? 0)
        member.profilePath = mwMember.profilePath
        member.character = mwMember.character
        member.order = Int64(mwMember.order ?? 0)
        member.name = mwMember.name

        guard let imageData = mwMember.image else { return }
        member.image = imageData
    }

    private func setMWMovieAdditionalInfoToCoreDataAdditionalInfo(mwInfo: MWMovieAdditionalInfo, for info: MovieAdditionalInfo) {
        info.adult = mwInfo.adult ?? false
        info.overview = mwInfo.overview
        info.runtime = Int64(mwInfo.runtime ?? 0)
        info.tagline = mwInfo.tagline
    }

    private func setMWImageConfigurationToCoreData(mwConfiguration: MWImageConfiguration, cdConfiguration: ImageConfiguration) {
        cdConfiguration.baseUrl = mwConfiguration.baseUrl
        cdConfiguration.secureBaseUrl = mwConfiguration.secureBaseUrl
        cdConfiguration.backdropSizes = mwConfiguration.backdropSizes
        cdConfiguration.logoSizes = mwConfiguration.logoSizes
        cdConfiguration.posterSizes = mwConfiguration.posterSizes
        cdConfiguration.profileSizes = mwConfiguration.profileSizes
        cdConfiguration.stillSizes = mwConfiguration.stillSizes
    }

    //MARK: - convert from core data actions

    private func convertImageConfiguration(from configuration: ImageConfiguration?) -> MWImageConfiguration {
        return MWImageConfiguration(
            baseUrl: configuration?.baseUrl,
            secureBaseUrl: configuration?.secureBaseUrl,
            backdropSizes: configuration?.backdropSizes,
            logoSizes: configuration?.logoSizes,
            posterSizes: configuration?.posterSizes,
            profileSizes: configuration?.profileSizes,
            stillSizes: configuration?.stillSizes)
    }

    private func convertFavoriteActors(from favoriteActors: [CastMember]) -> [[MWMovieCastMember]] {
        var mwMembers: [MWMovieCastMember] = []
        for actor in favoriteActors {
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

    private func convertFavoriteMovies(from movies: [Movie]) -> [MWMovie] {
        var mwMovies: [MWMovie] = []
        for movie in movies {
            let newMovie = MWMovie()
            newMovie.id = Int(movie.id)
            newMovie.posterPath = movie.posterPath
            newMovie.genreIds = movie.genreIds
            newMovie.title = movie.title
            newMovie.originalLanguage = movie.originalLanguage
            newMovie.releaseDate = movie.releaseDate
            newMovie.voteAvarage = movie.voteAvarage

            if let imageData = movie.movieImage {
                newMovie.image = imageData
            }
            newMovie.setMovieGenres(genres: MWSys.sh.genres)
            mwMovies.append(newMovie)
        }
        return mwMovies
    }

    private func convertAdditionalInfo(from info: MovieAdditionalInfo?) -> MWMovieAdditionalInfo {
        guard let info = info else { return MWMovieAdditionalInfo() }
        return MWMovieAdditionalInfo(adult: info.adult,
                                     overview: info.overview,
                                     runtime: Int(info.runtime),
                                     tagline: info.tagline)
    }

    private func convertMovies(movies: [Movie]) -> [MWMovie] {
        var mwMovies: [MWMovie] = []
        for movie in movies {
            let newMovie = MWMovie()
            newMovie.id = Int(movie.id)
            newMovie.posterPath = movie.posterPath
            newMovie.genreIds = movie.genreIds
            newMovie.title = movie.title
            newMovie.originalLanguage = movie.originalLanguage
            newMovie.releaseDate = movie.releaseDate
            newMovie.voteAvarage = movie.voteAvarage

            if let imageData = movie.movieImage {
                newMovie.image = imageData
            }
            newMovie.setMovieGenres(genres: MWSys.sh.genres)
            mwMovies.append(newMovie)
        }
        return mwMovies
    }
}
