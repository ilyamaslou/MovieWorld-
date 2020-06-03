//
//  CoreDataManager.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 6/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import CoreData

class CoreDataManager {
    static let s: CoreDataManager = CoreDataManager()

    let documentsDirectory: URL

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MWModel")
        container.persistentStoreDescriptions.forEach { (desc) in
            desc.shouldMigrateStoreAutomatically = true
            desc.shouldInferMappingModelAutomatically = true
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private init() {
        let docUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if docUrls.count > 0 {
            self.documentsDirectory = docUrls[0]
        } else {
            fatalError("not found documentDirectory")
        }
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
