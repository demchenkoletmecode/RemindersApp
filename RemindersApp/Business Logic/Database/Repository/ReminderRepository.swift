//
//  BaseDao.swift
//  RemindersApp
//
//  Created by Андрей on 14.11.2022.
//

import Foundation

protocol ReminderRepository {
    
    func createReminder(object: Reminder, completion: (Error?) -> Void)
    func getAllReminders(completion: (Result<[Reminder], Error>) -> Void)
    func getReminder(id: String, completion: (Result<[Reminder], Error>) -> Void)
    func updateReminder(object: Reminder, completion: (Error?) -> Void)
    func changeAccomplishment(object: Reminder, completion: (Error?) -> Void)
    func deleteReminder(object: Reminder, completion: (Error?) -> Void)
    
}
