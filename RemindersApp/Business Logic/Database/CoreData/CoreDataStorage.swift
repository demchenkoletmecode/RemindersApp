//
//  CoreDataStorageContext.swift
//  RemindersApp
//
//  Created by Андрей on 11.11.2022.
//

import CoreData
import Foundation

class CoreDataStorage<T>: StorageContext
where T: CoreDataConvertible, T.CoreDataType.ModelType == T {
    
    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RemindersApp")
        
        let storeDirectory = NSPersistentContainer.defaultDirectoryURL()
        let url = storeDirectory.appendingPathComponent("RemindersApp.sqlite")
        let description = NSPersistentStoreDescription(url: url)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(object: T) -> Error? {
        let context = persistentContainer.viewContext
        do {
            try object.saveEntity(in: context)
            saveContext()
            return nil
        } catch {
            print("An error occurred with saving data")
            return error
        }
    }
    
    func delete(object: T) -> Error? {
        let entity = object.uid
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<T.CoreDataType> = T.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", entity)
        do {
            if let result = (try context.fetch(fetchRequest).first) {
                context.delete(result)
            }
            saveContext()
            return nil
        } catch {
            print("An error occurred with updating data")
            return error
        }
    }
    
    func query(predicate: NSPredicate?) -> Result<[T], Error> {
        var objects = [T.CoreDataType]()
        do {
            let fetchRequest: NSFetchRequest<T.CoreDataType> = T.fetchRequest()
            fetchRequest.predicate = predicate
            objects = try context.fetch(fetchRequest) as [T.CoreDataType]
            let reminderObjects = objects.map {
                $0.toModel()
            }
            return .success(reminderObjects)
        } catch {
            print("An error occurred with fetching objects")
            return .failure(error)
        }
    }
    
}
