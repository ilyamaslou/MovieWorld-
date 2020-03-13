//
//  ImageConfiguration+CoreDataProperties.swift
//  
//
//  Created by Ilya Maslou on 3/14/20.
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
