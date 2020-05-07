//
//  MWCategoriesUrlPathsAndTitle.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/7/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation

enum MWCategoriesUrlPathsAndTitle: String, CaseIterable {

    //MARK:- cases

    case starWars = "Star Wars Collection"
    case hungerGames = "The Hunger Games Collection"
    case fastAndFurious = "The Fast and the Furious Collection"
    case lordOfTheRing = "The Lord of the Rings Collection"
    case ironMan = "Iron Man Collection"
    case harryPotter = "Harry Potter Collection"
    case jamesBond = "James Bond Collection"
    case avengers = "The Avengers Collection"
    case finalDestination = "Final Destination Collection"
    case backToTheFuture = "Back to the Future Collection"

    //MARK:- action with cases function

    func getCategoryUrlPath() -> String {
        var urlPath = ""
        switch self {
        case .starWars:
            urlPath = String(format: URLPaths.collectionOfMoviesById, 10)
        case .hungerGames:
            urlPath = String(format: URLPaths.collectionOfMoviesById, 131635)
        case .fastAndFurious:
            urlPath = String(format: URLPaths.collectionOfMoviesById, 9485)
        case .lordOfTheRing:
            urlPath = String(format: URLPaths.collectionOfMoviesById, 119)
        case .ironMan:
            urlPath = String(format: URLPaths.collectionOfMoviesById, 131292)
        case .harryPotter:
            urlPath = String(format: URLPaths.collectionOfMoviesById, 1241)
        case .jamesBond:
            urlPath = String(format: URLPaths.collectionOfMoviesById, 645)
        case .avengers:
            urlPath = String(format: URLPaths.collectionOfMoviesById, 86311)
        case .finalDestination:
            urlPath = String(format: URLPaths.collectionOfMoviesById, 8864)
        case .backToTheFuture:
            urlPath = String(format: URLPaths.collectionOfMoviesById, 264)

        }
        return urlPath
    }
}
