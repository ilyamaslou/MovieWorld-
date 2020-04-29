//
//  FavoriteActors+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/14/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
//

import CoreData

extension FavoriteActors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteActors> {
        return NSFetchRequest<FavoriteActors>(entityName: "FavoriteActors")
    }

    @NSManaged public var actors: NSSet?

}

// MARK: Generated accessors for actors
extension FavoriteActors {

    @objc(addActorsObject:)
    @NSManaged public func addToActors(_ value: CastMember)

    @objc(removeActorsObject:)
    @NSManaged public func removeFromActors(_ value: CastMember)

    @objc(addActors:)
    @NSManaged public func addToActors(_ values: NSSet)

    @objc(removeActors:)
    @NSManaged public func removeFromActors(_ values: NSSet)

}
