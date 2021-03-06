//
//  MWLanguageConfiguration.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

struct MWLanguageConfiguration: Decodable {

    //MARK:- enum

    enum CodingKeys: String, CodingKey {
        case iso = "iso_639_1"
        case englishName = "english_name"
    }

    //MARK:- action with parameters functions

    var iso: String?
    var englishName: String?
}
