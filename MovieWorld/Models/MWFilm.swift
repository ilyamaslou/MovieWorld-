//
//  MWFilm.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWFilm {
    let id: UUID = UUID()
    var filmName: String = "Green Book"
    var filmGenres: [String] = ["Comedy", "Drama", "Foreign"]
    var releaseYear: Int = 2018
    var filmCountry: String = "USA"
    var imbdRating: Double = 8.2
    var kpRating: Double = 8.3
    
    init() {
    }
    
    init(filmName: String,
         filmGenres: [String],
         releaseYear: Int,
         filmCountry: String,
         imbdRating: Double,
         kpRating: Double) {
        self.filmName = filmName
        self.filmGenres = filmGenres
        self.releaseYear = releaseYear
        self.filmCountry = filmCountry
        self.imbdRating = imbdRating
        self.kpRating = kpRating
        
    }
}
