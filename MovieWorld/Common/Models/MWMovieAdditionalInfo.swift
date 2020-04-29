//
//  MWMovieDetails.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/26/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWMovieAdditionalInfo: Decodable {

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case overview = "overview"
        case runtime = "runtime"
        case tagline = "tagline"
    }

    var adult: Bool?
    var overview: String?
    var runtime: Int?
    var tagline: String?
}
