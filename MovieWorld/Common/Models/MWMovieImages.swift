//
//  MWMovieImages.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/29/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation

class MWMovieImagesResponse: Decodable {
    let id: Int?
    let backdrops: [MWMovieImages]?
    var movieImages: [Data]?
}

struct MWMovieImages: Decodable {

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case height = "height"
        case width = "width"
    }

    let filePath: String?
    let height: Int?
    let width: Int?
}
