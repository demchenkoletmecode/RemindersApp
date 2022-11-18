//
//  Reminder+CoreDataConvertible.swift
//  RemindersApp
//
//  Created by Андрей on 14.11.2022.
//

import CoreData
import Foundation

extension Reminder: CoreDataConvertible {    
    
    typealias CoreDataType = ReminderItem
    
    var uid: String {
        return self.id
    }
    
    func saveEntity(in context: NSManagedObjectContext) throws {
        let fetchRequest = Self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", uid)
        fetchRequest.fetchLimit = 1
        if let existingRem = try context.fetch(fetchRequest).first {
            update(managedObject: existingRem, in: context)
        } else {
            self.toManagedObject(from: context)
        }
    }
    
    public static func fetchRequest() -> NSFetchRequest<ReminderItem> {
        let request = ReminderItem.fetchRequest() as NSFetchRequest<ReminderItem>
        return request
    }
    
    func toManagedObject(from context: NSManagedObjectContext) -> ReminderItem? {
        let reminderItem = ReminderItem(context: context)
        update(managedObject: reminderItem, in: context)
        return reminderItem
    }
    
    func update(managedObject: ReminderItem, in context: NSManagedObjectContext) {
        managedObject.id = self.id
        managedObject.name = self.name
        managedObject.isDone = self.isDone
        managedObject.periodicity = Int16(self.periodicity?.rawValue ?? -1)
        managedObject.timeDate = self.timeDate
        managedObject.isTimeSet = self.isTimeSet
        managedObject.notes = self.notes
        managedObject.updatedAt = self.updatedAt
    }
    
}
