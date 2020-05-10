//
//  MWFilm.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
import Foundation

struct MWMoviesResponse: Decodable {

    //MARK:- enum

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }

    //MARK:- Parameters

    let page: Int
    let results: [MWMovie]
    let totalResults: Int
    let totalPages: Int
}

class MWMovie: Decodable, Hashable {

    //MARK:- enum

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case posterPath = "poster_path"
        case title = "title"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case voteAvarage = "vote_average"
    }

    //MARK:- Parameters

    var id: Int?
    var posterPath: String?
    var title: String?
    var genreIds: [Int]?
    var releaseDate: String?
    var originalLanguage: String?
    var voteAvarage: Double?
    var movieGenres: [String]?
    var image: Data?

    //MARK: - initialization

    init() {}

    init(filmName: String,
         releaseYear: String,
         filmGenresIds: [Int]) {
        self.title = filmName
        self.releaseDate = releaseYear
        self.genreIds = filmGenresIds
    }

    init(id: Int,
         posterPath: String,
         title: String,
         filmGenresIds: [Int],
         releaseYear: String,
         originalLanguage: String,
         voteAverage: Double) {
        self.id = id
        self.posterPath = posterPath
        self.title = title
        self.releaseDate = releaseYear
        self.genreIds = filmGenresIds
        self.originalLanguage = originalLanguage
        self.voteAvarage = voteAverage
    }

    //MARK:- comparing object functions

    static func == (lhs: MWMovie, rhs: MWMovie) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.releaseDate == rhs.releaseDate &&
            lhs.posterPath == rhs.posterPath &&
            lhs.originalLanguage == rhs.originalLanguage &&
            lhs.genreIds == rhs.genreIds
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.title)
        hasher.combine(self.releaseDate)
        hasher.combine(self.posterPath)
        hasher.combine(self.originalLanguage)
        hasher.combine(self.genreIds)
    }

    //MARK:- action with parameters functions

    func setFilmGenres(genres: [MWGenre]) {
        guard let genreIds = self.genreIds  else { return }
        var tempGenres: [String] = []
        for id in genreIds {
            tempGenres.append(genres.filter{ $0.id == id }.first?.name ?? "")
        }
        self.movieGenres = tempGenres
    }

    func getMovieReleaseYear() -> String {
        return self.releaseDate?.separateDate(by: "-")?.first ?? ""
    }
}
