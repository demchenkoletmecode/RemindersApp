//
//  CoreDataStorageContext.swift
//  RemindersApp
//
//  Created by Андрей on 11.11.2022.
//

import CoreData
import Foundation

class CoreDataStorageContext<T>: StorageContext
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
    
    func save(object: T) -> Error?  {
        do {
            
            saveContext()
            return nil
        } catch {
            print("An error occurred with saving data")
            return error
        }
    }
    
    func query(predicate: NSPredicate?) -> [T] {
        var objects = [T]()
        do {
            let fetchRequest: NSFetchRequest<T.CoreDataType> = T.fetchRequest()
            fetchRequest.predicate = predicate
            objects = try context.fetch(fetchRequest) as? [T] ?? []
        } catch {
            print("An error occurred with fetching objects")
        }
        return objects
    }
    
    func delete(predicate: NSPredicate?) -> Error? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(T.self)")
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
            return nil
        } catch {
            print("An error occurred with deleting data: \(error.localizedDescription)")
            return error
        }
    }
    
}
