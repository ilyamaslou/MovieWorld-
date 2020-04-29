//
//  MovieAdditionalInfo+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/30/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
//

import CoreData

extension MovieAdditionalInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieAdditionalInfo> {
        return NSFetchRequest<MovieAdditionalInfo>(entityName: "MovieAdditionalInfo")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var overview: String?
    @NSManaged public var runtime: Int64
    @NSManaged public var tagline: String?
    @NSManaged public var movie: Movie?

}
