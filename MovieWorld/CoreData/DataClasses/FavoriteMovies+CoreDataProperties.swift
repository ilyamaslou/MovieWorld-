//
//  FavoriteMovies+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/2/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovies> {
        return NSFetchRequest<FavoriteMovies>(entityName: "FavoriteMovies")
    }

    @NSManaged public var movies: NSSet?

}

// MARK: Generated accessors for movies
extension FavoriteMovies {

    @objc(addMoviesObject:)
    @NSManaged public func addToMovies(_ value: Movie)

    @objc(removeMoviesObject:)
    @NSManaged public func removeFromMovies(_ value: Movie)

    @objc(addMovies:)
    @NSManaged public func addToMovies(_ values: NSSet)

    @objc(removeMovies:)
    @NSManaged public func removeFromMovies(_ values: NSSet)

}
