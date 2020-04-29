//
//  MWPersonDetails.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/4/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWMemberDetails: Decodable {

    enum CodingKeys: String, CodingKey {
        case birthday = "birthday"
        case deathday = "deathday"
        case id = "id"
        case name = "name"
        case department = "known_for_department"
        case biography = "biography"
    }

    var birthday: String?
    var deathday: String?
    var id: Int?
    var name: String?
    var department: String?
    var biography: String?
}
