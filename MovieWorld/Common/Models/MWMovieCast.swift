//
//  MWMovieCast.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/24/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation

struct MWMovieCastResponse: Decodable {

    //MARK:- Parameters

    let id: Int?
    var cast: [MWMovieCastMember]
    let crew: [MWMovieCrewMember]

    //MARK:- action with parameters function

    func getFullCast() -> [[Any]] {
        var fullCast: [[Any]] = []

        var cast: [MWMovieCastMember] = []
        for memberOfCast in self.cast {
            cast.append(memberOfCast)
        }
        fullCast.append(cast)

        let membersOfCrew: [String: [MWMovieCrewMember]] = Dictionary(grouping: self.crew,
                                                                      by: { ($0.job ?? "") } )
        for group in membersOfCrew {
            fullCast.append(group.value)
        }

        return fullCast
    }
}

class MWMovieCastMember: Decodable, PersonImageble {

    //MARK:- enum

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case character = "character"
        case name = "name"
        case order = "order"
        case profilePath = "profile_path"
    }

    //MARK:- Parameters

    var id: Int?
    var character: String?
    var name: String?
    var order: Int?
    var profilePath: String?
    var image: Data?

    //MARK: - initialization

    init() {}

    init(id: Int?,
         character: String?,
         name: String?,
         order: Int?,
         profilePath: String?,
         image: Data?) {
        self.id = id
        self.character = character
        self.name = name
        self.order = order
        self.profilePath = profilePath
        self.image = image
    }
}

class MWMovieCrewMember: Decodable, PersonImageble {

    //MARK:- enum

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case department = "department"
        case name = "name"
        case job = "job"
        case profilePath = "profile_path"
    }

    //MARK:- Parameters

    let id: Int?
    let department: String?
    let name: String?
    let job: String?
    let profilePath: String?
    var image: Data?
}

protocol PersonImageble {
    var image: Data? {get set}
}
