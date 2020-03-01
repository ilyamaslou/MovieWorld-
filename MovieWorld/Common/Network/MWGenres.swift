//
//  MWGenres.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/1/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

enum MWGenres: String {
    case drama = "Drama"
    case cartoon = "Cartoon"
    case horror = "Horror"
    
    // MARK: TO FIX
    static func getGenres(genresIds: [Int]?) -> [String] {
        var genres: [String] = []
        
        guard let genresIds = genresIds else {return [""]}
        for genreId in genresIds {
            switch genreId {
            case 1:
                genres.append(MWGenres.drama.rawValue)
            case 2:
                genres.append(MWGenres.cartoon.rawValue)
            case 3:
                genres.append(MWGenres.horror.rawValue)
            default:
                break
            }
        }
        
        return genres
    }
}
