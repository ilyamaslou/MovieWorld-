//
//  MWMovieGallery.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/30/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

struct MWMovieGallery {

    //MARK:- Parameters

    var images: [Data] = []
    var videos: [String] = []

    //MARK:- action with parameters function

    func getGalleryItems() -> [Any] {
        return videos + images
    }
}
