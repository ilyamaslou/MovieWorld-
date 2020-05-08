//
//  MWCategoriesModel.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/7/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation

struct MWCategoryModel: Decodable {

    //MARK: - enum

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case overview = "overview"
        case backdropPath = "backdrop_path"
        case parts = "parts"
    }

    //MARK:- Parameters

    var id: Int?
    var name: String?
    var overview: String?
    var backdropPath: String?
    var parts: [MWMovie]?
}
