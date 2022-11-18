//
//  CoreDataCovertible.swift
//  RemindersApp
//
//  Created by Андрей on 14.11.2022.
//

import CoreData
import Foundation

protocol CoreDataConvertible {
    
    associatedtype CoreDataType: ModelCovertible & NSManagedObject
    
    var uid: String { get }
    
    static func fetchRequest() -> NSFetchRequest<CoreDataType>
    func saveEntity(in context: NSManagedObjectContext) throws
    func toManagedObject(from context: NSManagedObjectContext) -> CoreDataType?
    func update(managedObject: CoreDataType, in context: NSManagedObjectContext)
    
}
