//
//  CastMember+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/30/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
//

import CoreData

extension CastMember {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CastMember> {
        return NSFetchRequest<CastMember>(entityName: "CastMember")
    }

    @NSManaged public var character: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var order: Int64
    @NSManaged public var profilePath: String?
    @NSManaged public var favoriteActors: FavoriteActors?

}
