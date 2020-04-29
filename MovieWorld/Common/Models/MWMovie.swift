//
//  MWFilm.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWMoviesResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }

    let page: Int
    let results: [MWMovie]
    let totalResults: Int
    let totalPages: Int
}

class MWMovie: Decodable, Hashable {

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case posterPath = "poster_path"
        case title = "title"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case voteAvarage = "vote_average"
    }

    var id: Int?
    var posterPath: String?
    var title: String?
    var genreIds: [Int]?
    var releaseDate: String?
    var originalLanguage: String?
    var voteAvarage: Double?
    var movieGenres: [String]?
    var image: Data?

    func setFilmGenres(genres: [MWGenre]) {
        var tmpGenres: [MWGenre] = []
        guard let genreIds = self.genreIds  else { return }
        for id in genreIds {
            tmpGenres.append(contentsOf: genres.filter { $0.id == id } )
        }
        self.movieGenres = tmpGenres.map { $0.name }
    }

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

    static func == (lhs: MWMovie, rhs: MWMovie) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.releaseDate == rhs.releaseDate &&
            lhs.posterPath == rhs.posterPath &&
            lhs.originalLanguage == rhs.originalLanguage &&
            lhs.genreIds == rhs.genreIds
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(releaseDate)
        hasher.combine(posterPath)
        hasher.combine(originalLanguage)
        hasher.combine(genreIds)
    }
}
