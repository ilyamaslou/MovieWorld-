//
//  MWConfiguration.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/6/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWConfiguration: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
    
    let images: MWImageConfiguration?
    let changeKeys: [String]?
}
