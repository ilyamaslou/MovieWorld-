//
//  MWPersonMovies.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWPersonMoviesResponse: Decodable {
    var results: [MWPersonMovies]?
}

struct MWPersonMovies: Decodable {

    enum CodingKeys: String, CodingKey {
        case knownFor = "known_for"
    }

    var knownFor: [MWMovie]?
}
