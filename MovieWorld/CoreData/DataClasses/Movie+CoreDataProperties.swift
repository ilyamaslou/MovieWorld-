//
//  Movie+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/2/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var genreIds: [Int]?
    @NSManaged public var id: Int64
    @NSManaged public var movieGenres: [String]?
    @NSManaged public var movieImage: Data?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAvarage: Double
    @NSManaged public var additionalInfo: MovieAdditionalInfo?
    @NSManaged public var category: MovieCategory?
    @NSManaged public var favorite: FavoriteMovies?

}
