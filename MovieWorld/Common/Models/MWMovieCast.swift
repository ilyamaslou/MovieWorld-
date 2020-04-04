//
//  MWMovieCast.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/24/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation

struct MWMovieCastResponse: Decodable {
    let id: Int?
    let cast: [MWMovieCastMember]
    let crew: [MWMovieCrewMember]
    
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

class MWMovieCastMember: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "cast_id"
        case character = "character"
        case creditId = "credit_id"
        case name = "name"
        case order = "order"
        case profilePath = "profile_path"
    }
    
    let id: Int?
    let character: String?
    let creditId: String?
    let name: String?
    let order: Int?
    let profilePath: String?
    var image: Data?
}

class MWMovieCrewMember: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case creditId = "credit_id"
        case department = "department"
        case name = "name"
        case job = "job"
        case profilePath = "profile_path"
    }
    
    let id: Int?
    let creditId: String?
    let department: String?
    let name: String?
    let job: String?
    let profilePath: String?
    var image: Data?
}
