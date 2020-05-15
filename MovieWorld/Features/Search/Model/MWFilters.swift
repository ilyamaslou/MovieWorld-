//
//  MWFilters.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/15/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

struct MWFilters {
    var genres: Set<String>?
    var countries: [String?]?
    var year: String?
    var ratingRange: (Float, Float)?
}
