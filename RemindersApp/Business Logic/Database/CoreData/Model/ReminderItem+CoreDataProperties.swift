//
//  ReminderItem+CoreDataProperties.swift
//  
//
//  Created by Андрей on 21.10.2022.
//
//

import CoreData
import Foundation

public extension ReminderItem {

    @nonobjc
    class func fetchRequest() -> NSFetchRequest<ReminderItem> {
        return NSFetchRequest<ReminderItem>(entityName: "ReminderItem")
    }

    @NSManaged var id: String
    @NSManaged var isDone: Bool
    @NSManaged var name: String
    @NSManaged var notes: String?
    @NSManaged var periodicity: Int16
    @NSManaged var timeDate: Date?
    @NSManaged var isTimeSet: Bool
    @NSManaged var updatedAt: Date

}
