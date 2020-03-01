//
//  MWFilm.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//



import UIKit

struct MWPopularMoviesResponse: Decodable {
    let page: Int
    let results: [MWPopularMovie]
}

struct MWPopularMovie: Decodable {
    
    var id: Int?
    var poster_path: String?
    var title: String?
    var genre_ids: [Int]?
    var release_date: String?
    var original_language: String?
    
    init() {
    }
    
    init(filmName: String,
         releaseYear: String,
         filmGenresIds: [Int]) {
        self.title = filmName
        self.release_date = releaseYear
        self.genre_ids = filmGenresIds
    }
    
    init(id: Int,
         poster_path: String,
         title: String,
         filmGenresIds: [Int],
         releaseYear: String,
         original_language: String
    ) {
        self.id = id
        self.poster_path = poster_path
        self.title = title
        self.release_date = releaseYear
        self.genre_ids = filmGenresIds
        self.original_language = original_language
    }
    
    
}

