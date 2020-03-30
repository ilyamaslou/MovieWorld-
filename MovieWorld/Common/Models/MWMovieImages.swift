//
//  MWMovieImages.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/29/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWMovieImagesResponse: Decodable {
    var id: Int?
    var backdrops: [MWMovieImages]?
    var movieImages: [Data]?
}

struct MWMovieImages: Decodable {
    
    enum CodingKeys: String, CodingKey {
           case filePath = "file_path"
           case height = "height"
           case width = "width"
       }
    
    var filePath: String?
    var height: Int?
    var width: Int?
}


