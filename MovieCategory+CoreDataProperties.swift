//
//  MovieCategory+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/26/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
//

import Foundation
import CoreData


extension MovieCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCategory> {
        return NSFetchRequest<MovieCategory>(entityName: "MovieCategory")
    }

    @NSManaged public var movieCategory: String?
    @NSManaged public var movies: NSSet?

}

// MARK: Generated accessors for movies
extension MovieCategory {

    @objc(addMoviesObject:)
    @NSManaged public func addToMovies(_ value: Movie)

    @objc(removeMoviesObject:)
    @NSManaged public func removeFromMovies(_ value: Movie)

    @objc(addMovies:)
    @NSManaged public func addToMovies(_ values: NSSet)

    @objc(removeMovies:)
    @NSManaged public func removeFromMovies(_ values: NSSet)

}
