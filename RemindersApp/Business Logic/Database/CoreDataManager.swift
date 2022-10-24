//
//  NSManager.swift
//  RemindersApp
//
//  Created by Андрей on 20.10.2022.
//

import CoreData
import Foundation

class CoreDataManager {
    
    private lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RemindersApp")
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
    
    func fetchReminders() -> [Reminder] {
        var reminders = [Reminder]()
        do {
            var remindersItems = [ReminderItem]()
            remindersItems = try context.fetch(ReminderItem.fetchRequest())
            reminders = remindersItems.map { rem in
                Reminder(id: rem.id,
                         name: rem.name,
                         isDone: rem.isDone,
                         timeDate: rem.timeDate,
                         periodicity: rem.periodicity?.toPeriodicity,
                         notes: rem.notes)
            }
        } catch {
            print("An error occurred with fetching reminders")
        }
        
        return reminders
    }
    
    func addReminder(reminder: Reminder) {
        let reminderItem = ReminderItem(context: context)
        reminderItem.id = reminder.id
        reminderItem.name = reminder.name
        reminderItem.isDone = reminder.isDone
        reminderItem.periodicity = reminder.periodicity?.toString()
        reminderItem.timeDate = reminder.timeDate
        reminderItem.notes = reminder.notes
        
        do {
            try context.save()
        } catch {
            print("An error occurred with saving reminder")
        }
    }
    
    func getReminderById(reminderId: String) -> Reminder? {
        var reminder: Reminder?
        do {
            let request = ReminderItem.fetchRequest() as NSFetchRequest<ReminderItem>
            let pred = NSPredicate(format: "id = %@", reminderId)
            request.predicate = pred
            
            let reminderItem = try context.fetch(request).first ?? ReminderItem(context: context)
            
            reminder = Reminder(id: reminderItem.id,
                                name: reminderItem.name,
                                isDone: reminderItem.isDone,
                                timeDate: reminderItem.timeDate,
                                periodicity: reminderItem.periodicity?.toPeriodicity,
                                notes: reminderItem.notes)
        } catch {
            print("An error occurred with getting reminder by id")
        }
        return reminder
    }
    
    func editReminder(id: String, reminder: Reminder) {
        let fetchReminder: NSFetchRequest<ReminderItem> = ReminderItem.fetchRequest()
        fetchReminder.predicate = NSPredicate(format: "id = %@", id as String)

        let results = try? context.fetch(fetchReminder)
        let reminderItem = results?.first ?? ReminderItem(context: context)

        reminderItem.id = id
        reminderItem.name = reminder.name
        reminderItem.isDone = reminder.isDone
        reminderItem.periodicity = reminder.periodicity?.toString()
        reminderItem.timeDate = reminder.timeDate
        reminderItem.notes = reminder.notes
        
        do {
            try context.save()
        } catch {
            print("An error occurred with updating reminder!")
        }
    }
    
    func changeAccomplishment(id: String) {
        let fetchReminder: NSFetchRequest<ReminderItem> = ReminderItem.fetchRequest()
        fetchReminder.predicate = NSPredicate(format: "id = %@", id as String)

        let results = try? context.fetch(fetchReminder)
        let reminderItem = results?.first ?? ReminderItem(context: context)

        reminderItem.id = id
        reminderItem.isDone = !reminderItem.isDone
        do {
            try context.save()
        } catch {
            print("An error occurred with changing accomplishment in reminder!")
        }
    }
}
