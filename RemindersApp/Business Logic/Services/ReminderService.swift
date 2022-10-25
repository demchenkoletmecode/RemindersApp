//
//  ReminderService.swift
//  RemindersApp
//
//  Created by Андрей on 25.10.2022.
//

import Foundation

protocol MainReminderServiceDelegate: AnyObject {
    
    func onRemindersRetrieved(reminders: [ReminderRemoteItem]?)
    func onReminderDeleted(with id: String)
    func onError(error: Error)
    
}

protocol AddEditReminderServiceDelegate: AnyObject {
    
    func onNewReminderPosted(reminder: ReminderRemoteItem?)
    func onReminderDetailFetched(reminder: ReminderRemoteItem?)
    func onReminderUpdated(reminder: ReminderRemoteItem?)
    func onError(error: Error)
    
}

class ReminderService {
    
    weak var mainDelegate: MainReminderServiceDelegate?
    weak var addEditDelegate: AddEditReminderServiceDelegate?
    
    func deleteReminder(with id: String) {
        RemindersEndpoint.deleteReminder(id).remove { [weak self] in
            self?.mainDelegate?.onReminderDeleted(with: id)
        } onError: { [weak self] error in
            self?.mainDelegate?.onError(error: error)
        }
    }
    
    func postReminder(reminder: ReminderRemoteItem?) {
        guard let reminderId: String = reminder?.id else { return }
        RemindersEndpoint.postReminder(reminderId).post(data: reminder, createNewKey: false) { [weak self] result in
            switch result {
            case .success(let reminder):
                self?.addEditDelegate?.onNewReminderPosted(reminder: reminder)
            case .failure(let error):
                self?.addEditDelegate?.onError(error: error)
            }
        }
    }
    
    func getAllReminders() {
        RemindersEndpoint.getAllReminders.retrieve(completion: { [weak self] (rem: [ReminderRemoteItem]?) in
            self?.mainDelegate?.onRemindersRetrieved(reminders: rem)
        }) { [weak self] error in
            self?.mainDelegate?.onError(error: error)
        }
    }
    
    func getReminderDetail(with id: String) {
        RemindersEndpoint.getReminderDetail(id).retrieve(completion: { [weak self] (reminder: ReminderRemoteItem?) in
            self?.addEditDelegate?.onReminderDetailFetched(reminder: reminder)
        }) { [weak self] error in
            self?.addEditDelegate?.onError(error: error)
        }
    }
    
    func updateReminder(with id: String, reminder: ReminderRemoteItem?) {
        RemindersEndpoint.updateReminder(id).update(data: reminder) {  [weak self] result in
            switch result {
            case .success(let reminder):
                self?.addEditDelegate?.onReminderUpdated(reminder: reminder)
            case .failure(let error):
                self?.addEditDelegate?.onError(error: error)
            }
        }
    }
    
}
