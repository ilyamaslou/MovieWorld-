//
//  Notification + Ex.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/25/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let movieImageUpdated = Notification.Name("movieImagesUpdated")
    static let memberMovieImageUpdated = Notification.Name("memberMovieImageUpdated")
    static let memberImageUpdated = Notification.Name("memberImagesUpdated")
    static let movieImagesCollectionUpdated = Notification.Name("movieImagesCollectionUpdated")
    static let genresChanged = Notification.Name("genresChanged")
}
