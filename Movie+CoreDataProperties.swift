//
//  Movie+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/1/20.
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
    @NSManaged public var category: MovieCategory?
    @NSManaged public var additionalInfo: MovieAdditionalInfo?

}

extension Movie {

    @objc(addAdditionalInfoObject:)
    @NSManaged public func addToAdditionalInfo(_ value: MovieAdditionalInfo)

    @objc(removeAdditionalInfoObject:)
    @NSManaged public func removeFromAdditionalInfo(_ value: MovieAdditionalInfo)

    @objc(addAdditionalInfo:)
    @NSManaged public func addToAdditionalInfo(_ values: NSSet)

    @objc(removeAdditionalInfo:)
    @NSManaged public func removeFromAdditionalInfo(_ values: NSSet)

}
