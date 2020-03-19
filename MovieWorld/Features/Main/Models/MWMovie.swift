//
//  MWFilm.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
import UIKit

struct MWMoviesResponse: Decodable {
    let page: Int
    let results: [MWMovie]
}

class MWMovie: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "status_code"
        case posterPath = "poster_path"
        case title = "title"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
    }
    
    var id: Int?
    var posterPath: String?
    var title: String?
    var genreIds: [Int]?
    var releaseDate: String?
    var originalLanguage: String?
    var movieGenres: [String]?
    var movieImage: Data?
    
    func setFilmGenres(genres: [MWGenre]) {
        var tempGenres: [String] = []
        guard let genreIds = genreIds  else { return }
        for id in genreIds {
            for genre in genres {
                if genre.id == id {
                    tempGenres.append(genre.name)
                }
            }
        }
        movieGenres = tempGenres
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
         poster_path: String,
         title: String,
         filmGenresIds: [Int],
         releaseYear: String,
         original_language: String) {
        self.id = id
        self.posterPath = poster_path
        self.title = title
        self.releaseDate = releaseYear
        self.genreIds = filmGenresIds
        self.originalLanguage = original_language
    }
}
