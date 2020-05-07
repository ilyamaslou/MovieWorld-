//
//  URLPaths.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/8/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

struct URLPaths {
    static let getLanguages: String = "configuration/languages"
    static let trandingDayMovies: String = "trending/movie/day"
    static let searchMovies: String = "search/movie"
    static let popularMovies: String = "movie/popular"
    static let topRatedMovies: String = "movie/top_rated"
    static let nowPlayingMovies: String = "movie/now_playing"
    static let upcomingMovies: String = "movie/upcoming"
    static let getGenres: String = "genre/movie/list"
    static let getConfiguration: String = "configuration"
    static let searchPerson: String = "search/person"
    static let getVideo = "https://www.youtube.com/watch?v=%@"
    static let getMovieVideos = "movie/%d/videos"
    static let getMovieCredits = "movie/%d/credits"
    static let movieAdditionalInfo = "movie/%d"
    static let movieImages = "movie/%d/images"
    static let personInfo = "person/%d"
    static let personMovies = "search/person"
    static let collectionOfMoviesById = "collection/%d"
    static let dailyCollectionsURL = "https://files.tmdb.org/p/exports/collection_ids_05_06_2020.json.gz"
}
