//
//  MWSpecialError.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/2/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWSpecialError: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code", statusMessage = "status_message"
    }
    
    var statusCode: Int?
    var statusMessage: String?
    
    init() {
    }
}
