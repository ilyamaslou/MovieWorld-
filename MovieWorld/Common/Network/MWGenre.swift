//
//  MWGenre.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/1/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWGenreResponse: Decodable {
    let genres: [MWGenre]
}

struct MWGenre: Decodable {
    let id: Int
    let name: String
    
    init(id: Int,
         name: String) {
        self.id = id
        self.name = name
    }
}
