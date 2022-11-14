//
//  DBManager.swift
//  RemindersApp
//
//  Created by Андрей on 14.11.2022.
//

import Foundation

class ReminderRepositoryImpl<S> where S: StorageContext, S.T == Reminder {
    
    private var storage: S
    
    init(storage: S) {
        self.storage = storage
    }

}

extension ReminderRepositoryImpl: ReminderRepository {
    
    func createReminder(object: Reminder, completion: (Error?) -> Void) {
        completion(storage.save(object: object))
    }
    
    func getAllReminders(completion: (Result<[Reminder], Error>) -> Void) {
        completion(storage.query(predicate: nil))
    }
    
    func updateReminder(object: Reminder, completion: (Error?) -> Void) {
        completion(storage.save(object: object))
    }
    
    func changeAccomplishment(object: Reminder, completion: (Error?) -> Void) {
        completion(storage.save(object: object))
    }
    
    func deleteReminder(object: Reminder, completion: (Error?) -> Void) {
        
    }
    
}
