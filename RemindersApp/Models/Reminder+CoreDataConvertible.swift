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
    
    func saveEntity(in context: NSManagedObjectContext) {
        let reminder = self.toManagedObject(from: context)
        if let reminder = reminder {
            do {
                //try coreDataManager.save(object: reminder)
            } catch {
                print("An error occurred with saving entity")
            }
        }
    }
    
    static func fetchRequest() -> NSFetchRequest<ReminderItem> {
        let request = ReminderItem.fetchRequest() as NSFetchRequest<ReminderItem>
        return request
    }
    
    func toManagedObject(from context: NSManagedObjectContext) -> ReminderItem? {
        let reminderItem = ReminderItem(context: context)
        reminderItem.id = self.id
        reminderItem.name = self.name
        reminderItem.isDone = self.isDone
        reminderItem.periodicity = Int16(self.periodicity?.rawValue ?? -1)
        reminderItem.timeDate = self.timeDate
        reminderItem.isTimeSet = self.isTimeSet
        reminderItem.notes = self.notes
        reminderItem.updatedAt = self.updatedAt
        return reminderItem
    }
    
    func update(managedObject: ReminderItem, in context: NSManagedObjectContext) {
        //appContext.coreDateManager2.query(ReminderItem.Type, predicate: T##NSPredicate?)
    }
    
}
