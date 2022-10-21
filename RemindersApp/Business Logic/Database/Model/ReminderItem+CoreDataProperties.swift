//
//  ReminderItem+CoreDataProperties.swift
//  RemindersApp
//
//  Created by Андрей on 17.10.2022.
//
//

import Foundation
import CoreData


extension ReminderItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderItem> {
        return NSFetchRequest<ReminderItem>(entityName: "ReminderItem")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var timeDate: Date?
    @NSManaged public var periodicity: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var notes: String?

}

extension ReminderItem : Identifiable {

}
