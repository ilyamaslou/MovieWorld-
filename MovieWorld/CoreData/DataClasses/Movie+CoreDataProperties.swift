//
//  Movie+CoreDataProperties
//  MovieWorld
//
//  Created by Ilya Maslou on 3/16/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var posterPath: String?
    @NSManaged public var title: String?
    @NSManaged public var genreIds: [Int]?
    @NSManaged public var releaseDate: String?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var movieGenres: [String]?
    @NSManaged public var movieImage: Data?
    @NSManaged public var category: MovieCategory?

}
