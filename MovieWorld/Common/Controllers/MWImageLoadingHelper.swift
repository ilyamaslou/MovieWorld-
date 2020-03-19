//
//  MWImageLoadingHelper.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/19/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import CoreData

class MWImageLoadingHelper{
    
    static let sh = MWImageLoadingHelper()
    
    private init() {}
    
    func loadImage(for movie: MWMovie, in category: String) {
        if let imagePath = movie.posterPath,
            let baseUrl = MWSys.sh.configuration?.images?.secureBaseUrl,
            let size = MWSys.sh.configuration?.images?.posterSizes?.first {
            MWNet.sh.imageRequest(baseUrl: baseUrl,
                                  size: size,
                                  filePath: imagePath,
                                  succesHandler: { [weak self] (imageData: Data)  in
                                    guard let self = self else { return }
                                    
                                    movie.movieImage = imageData
                                    self.saveImage(for: movie, imageData: imageData, in: category)
                }
            )
        }
    }
    
    private func fetchMovie(for movie: MWMovie, in category: String) -> Movie? {
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetch.predicate = NSPredicate(format: "ANY title = %@ and category.movieCategory = %@", movie.title ?? "", category)
        
        var movie: Movie?
        do {
            movie = try managedContext.fetch(fetch).first
        } catch {
            print(error.localizedDescription)
        }
        return movie
    }
    
    private func saveImage(for movie: MWMovie, imageData: Data, in category: String) {
        let result = self.fetchMovie(for: movie, in: category)
        result?.movieImage = imageData
        
        let managedContext = CoreDataManager.s.persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
