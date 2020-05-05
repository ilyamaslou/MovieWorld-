//
//  MWImageConfiguration.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/8/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

struct MWImageConfiguration: Decodable {

    //MARK:- enums

    enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
        case secureBaseUrl = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }

    enum Sizes: String, Decodable {
        case w45, w92, w154, w185, w300, w342, w500, h632, w780, w1280, original, unkown

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self = try Sizes(rawValue: (container.decode(RawValue.self))) ?? .unkown
        }
    }

    //MARK:- Parameters

    var baseUrl: String?
    var secureBaseUrl: String?
    var backdropSizes: [Sizes.RawValue]?
    var logoSizes: [Sizes.RawValue]?
    var posterSizes: [Sizes.RawValue]?
    var profileSizes: [Sizes.RawValue]?
    var stillSizes: [Sizes.RawValue]?

    //MARK: - initialization

    init() {}

    init(baseUrl: String?,
         secureBaseUrl: String?,
         backdropSizes: [String]?,
         logoSizes: [String]?,
         posterSizes: [String]?,
         profileSizes: [String]?,
         stillSizes: [String]?) {
        self.baseUrl = baseUrl
        self.secureBaseUrl = secureBaseUrl
        self.backdropSizes = backdropSizes
        self.logoSizes = logoSizes
        self.posterSizes = posterSizes
        self.profileSizes = profileSizes
        self.stillSizes = stillSizes
    }
}
