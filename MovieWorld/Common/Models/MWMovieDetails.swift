//
//  MWMovieDetails.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/26/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWMovieDetails: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case overview = "overview"
        case releaseDate = "release_date"
        case runtime = "runtime"
        case voteAvarage = "vote_average"
        case voteCount = "vote_count"
        case tagline = "tagline"
    }
    
    let adult: Bool?
    let overview: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAvarage: Double?
    let voteCount: Int?
    let tagline: String?
}
