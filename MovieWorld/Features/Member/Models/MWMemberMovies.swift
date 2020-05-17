//
//  MWPersonMovies.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

struct MWMwmberMoviesResponse: Decodable {
    var results: [MWMemberMovies]?
}

struct MWMemberMovies: Decodable {

    //MARK:- enum

    enum CodingKeys: String, CodingKey {
        case knownFor = "known_for"
    }

    //MARK:- parameter

    var knownFor: [MWMovie]?
}
