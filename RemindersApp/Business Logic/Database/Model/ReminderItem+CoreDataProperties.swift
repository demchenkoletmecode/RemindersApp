//
//  ReminderItem+CoreDataProperties.swift
//  RemindersApp
//
//  Created by Андрей on 17.10.2022.
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
    @NSManaged var name: String
    @NSManaged var timeDate: Date?
    @NSManaged var periodicity: String?
    @NSManaged var isDone: Bool
    @NSManaged var notes: String?

}

extension ReminderItem: Identifiable {

}
