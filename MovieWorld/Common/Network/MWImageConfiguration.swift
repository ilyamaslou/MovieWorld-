//
//  MWImageConfiguration.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/8/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation

struct MWImageConfiguration: Decodable {
    
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
    
    var baseUrl :String?
    var secureBaseUrl :String?
    var backdropSizes: [Sizes.RawValue]?
    var logoSizes: [Sizes.RawValue]?
    var posterSizes: [Sizes.RawValue]?
    var profileSizes: [Sizes.RawValue]?
    var stillSizes: [Sizes.RawValue]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseUrl = (try? container.decode(String.self, forKey: .baseUrl)) ?? ""
        self.secureBaseUrl = (try? container.decode(String.self, forKey: .secureBaseUrl)) ?? ""
        self.backdropSizes = (try? container.decode([String].self, forKey: .backdropSizes))
        self.logoSizes = (try? container.decode([String].self, forKey: .logoSizes))
        self.posterSizes = (try? container.decode([String].self, forKey: .posterSizes))
        self.profileSizes = (try? container.decode([String].self, forKey: .profileSizes))
        self.stillSizes = (try? container.decode([String].self, forKey: .stillSizes))
    }
}
