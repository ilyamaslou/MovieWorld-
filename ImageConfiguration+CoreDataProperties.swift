//
//  ImageConfiguration+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/14/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageConfiguration> {
        return NSFetchRequest<ImageConfiguration>(entityName: "ImageConfiguration")
    }

    @NSManaged public var backdropSizes: [String]?
    @NSManaged public var baseUrl: String?
    @NSManaged public var logoSizes: [String]?
    @NSManaged public var posterSizes: [String]?
    @NSManaged public var profileSizes: [String]?
    @NSManaged public var secureBaseUrl: String?
    @NSManaged public var stillSizes: [String]?

}
