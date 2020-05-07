//
//  MWCategoriesModel.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/7/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation

struct MWCategoriesModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    var id: Int?
    var name: String?

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
