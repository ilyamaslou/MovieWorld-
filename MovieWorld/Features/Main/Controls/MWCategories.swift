//
//  MWCategories.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/20/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

enum MWCategories: String, CaseIterable {

    //MARK:- cases

    case popularMovies = "Popular Movies"
    case nowPlayingMovies = "Now Playing Movies"
    case topRatedMovies = "Top Rated"
    case upcomingMovies = "Upcoming Movies"

    //MARK:- action with cases function

    func getCategoryUrlPath() -> String {
        var urlPath = ""
        switch self {
        case .popularMovies:
            urlPath = URLPaths.popularMovies
        case .nowPlayingMovies:
            urlPath = URLPaths.nowPlayingMovies
        case .topRatedMovies:
            urlPath = URLPaths.topRatedMovies
        case .upcomingMovies:
            urlPath = URLPaths.upcomingMovies
        }
        return urlPath
    }
}
