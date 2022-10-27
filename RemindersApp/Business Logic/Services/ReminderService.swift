//
//  ReminderService.swift
//  RemindersApp
//
//  Created by Андрей on 25.10.2022.
//

import Foundation

class ReminderService {
    
    private lazy var firebaseManager = FirebaseDatabaseManager()
    
    func deleteReminder(with id: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = RemindersEndpoint.deleteReminder(id)
        firebaseManager.remove(from: endpoint) { result in
            switch result {
            case .success:
                completion(.success(id))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func postReminder(reminder: ReminderRemoteItem, completion: @escaping (Result<String, Error>) -> Void) {
        let reminderId = reminder.id
        let endpoint = RemindersEndpoint.postReminder(reminderId)
        firebaseManager.post(from: endpoint,
                             data: reminder,
                             createNewKey: false) { result in
            switch result {
            case .success:
                completion(.success(reminderId))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getAllReminders(completion: @escaping (Result<[ReminderRemoteItem], Error>) -> Void) {
        let endpoint = RemindersEndpoint.getAllReminders
        firebaseManager.readOnce(from: endpoint, dataType: [ReminderRemoteItem].self) { result in
            switch result {
            case let .success(reminders):
                completion(.success(reminders))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getReminderDetail(with id: String, completion: @escaping (Result<ReminderRemoteItem, Error>) -> Void) {
        let endpoint = RemindersEndpoint.getReminderDetail(id)
        firebaseManager.readOnce(from: endpoint, dataType: ReminderRemoteItem.self) { result in
            switch result {
            case let .success(reminder):
                completion(.success(reminder))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func updateReminder(with id: String,
                        reminder: ReminderRemoteItem,
                        completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = RemindersEndpoint.updateReminder(id)
        firebaseManager.update(from: endpoint, data: reminder) { result in
            switch result {
            case .success:
                completion(.success(id))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
