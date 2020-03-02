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
    
    // MARK: TO FIX
//    static func getGenres(genresIds: [Int]?) -> [String] {
//        var genres: [String] = []
//
//        guard let genresIds = genresIds else { return [""] }
//        for genreId in genresIds {
//            switch genreId {
//            case 1:
//                genres.append(MWGenre.drama.rawValue)
//            case 2:
//                genres.append(MWGenre.cartoon.rawValue)
//            case 3:
//                genres.append(MWGenre.horror.rawValue)
//            default:
//                break
//            }
//        }
//
//        return genres
//    }
}
