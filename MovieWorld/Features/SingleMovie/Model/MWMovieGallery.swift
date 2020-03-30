//
//  MWMovieGallery.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/30/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWMovieGallery {
    var images: [Data] = []
    var videos: [String] = []
    
    func getGalleryItems() -> [Any] {
        return videos + images
    }
}
