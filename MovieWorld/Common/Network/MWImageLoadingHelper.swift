//
//  MWImageLoadingHelper.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/19/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation
import CoreData

class MWImageLoadingHelper{

    //MARK:- static variables

    static let sh = MWImageLoadingHelper()

    //MARK: - initialization

    private init() {}

    //MARK:- request functions

    func loadMovieImage(for movie: MWMovie, in category: String = "") {
        //TODO: change poster size later by providing getNextSize() in Sizes
        if let imagePath = movie.posterPath,
            let baseUrl = MWSys.sh.configuration?.images?.secureBaseUrl,
            let size = MWSys.sh.configuration?.images?.posterSizes?.first {
            MWNet.sh.imageRequest(baseUrl: baseUrl,
                                  size: size,
                                  filePath: imagePath,
                                  succesHandler: { [weak self] (imageData: Data)  in
                                    guard let self = self else { return }

                                    movie.image = imageData
                                    NotificationCenter.default.post(name: .movieImageUpdated, object: nil)

                                    guard !category.isEmpty else { return }
                                    self.saveImage(for: movie, imageData: imageData, in: category)
            })
        }
    }

    func loadPersonImage<T: PersonImageble>(for person: T, path: String?) {
        var personToChange = person
        if let imagePath = path,
            let baseUrl = MWSys.sh.configuration?.images?.secureBaseUrl,
            let size = MWSys.sh.configuration?.images?.posterSizes?.first {
            MWNet.sh.imageRequest(baseUrl: baseUrl,
                                  size: size,
                                  filePath: imagePath,
                                  succesHandler: { (imageData: Data)  in
                                    personToChange.image = imageData
                                    NotificationCenter.default.post(name: .memberImageUpdated, object: nil)
            })
        }
    }

    //TODO: fix problems with sizes and make this less hardcoded
    func loadMovieImages(for imagesToLoad: MWMovieImagesResponse?) {
        guard let backdrops = imagesToLoad?.backdrops else { return }

        if imagesToLoad?.movieImages == nil {
            imagesToLoad?.movieImages = []
        }

        for image in backdrops {
            let size = "original"
            guard let imagePath = image.filePath,
                let imagesResponse = imagesToLoad,
                let baseUrl = MWSys.sh.configuration?.images?.secureBaseUrl else  { break }
            MWNet.sh.imageRequest(baseUrl: baseUrl,
                                  size: size,
                                  filePath: imagePath,
                                  succesHandler: { (imageData: Data) in
                                    imagesResponse.movieImages?.append(imageData)
                                    NotificationCenter.default.post(name: .movieImagesCollectionUpdated, object: nil)
            })
        }
    }

    //MARK:- Core Data actions

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
