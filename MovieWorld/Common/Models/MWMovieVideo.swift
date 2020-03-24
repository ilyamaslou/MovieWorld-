//
//  MWMovieVideo.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation
import UIKit

struct MWMovieVideoResponse: Decodable {
    let id: Int?
    let results: [MWMovieVideo]
}

struct MWMovieVideo: Decodable {
    let id: String?
    let name: String?
    let key: String?
    let site: String?
    let size: Int?
    let type: String?
}
