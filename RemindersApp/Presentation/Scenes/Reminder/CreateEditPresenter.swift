//
//  CreateEditPresenter.swift
//  RemindersApp
//
//  Created by Андрей on 14.10.2022.
//

import Foundation

protocol CreateEditProtocol: AnyObject {
    var name: String { get }
    var isDateSelected: Bool { get set }
    var date: Date? { get set }
    var dateString: String? { get }
    var isTimeSelected: Bool { get set }
    var time: Date? { get set }
    var timeString: String? { get }
    var periodicity: Int? { get }
    var notes: String? { get }
    
    func showReminder(reminder: Reminder?)
    func save()
    func update(nameError: String?)
}

class CreateEditPresenter {
    
    weak var view: CreateEditProtocol?
    private var reminderId: String? = nil
    private var reminder: Reminder?
    private var fullDate: Date?
    private let calendar = Calendar.current
    private let coreDataManager = appContext.coreDateManager
    private let reminderService: ReminderService
    
    var periodList = Periodicity.allCases.map {
        $0.displayValue
    }
    
    init(view: CreateEditProtocol, reminderService: ReminderService, id: String?) {
        self.view = view
        self.reminderService = reminderService
        self.reminderService.addEditDelegate = self
        self.reminderId = id
    }
    
    func isEditReminder() -> Bool {
        return reminderId != nil
    }
    
    func tapSaveEditReminder() {
        let name = view?.name ?? ""
        if validName(name) {
            var periodicity: Int
            if view?.periodicity != nil {
                periodicity = view?.periodicity ?? -1
            } else {
                periodicity = reminder?.periodicity?.rawValue ?? -1
            }
            let notes = view?.notes
            if let date = view?.date {
                fullDate = calendar.date(from: date.dateComponentsFromDate)
            } else {
                fullDate = reminder?.timeDate
            }
            if let reminderId = reminderId, let reminder = reminder {
                //coreDataManager.editReminder(id: reminderId, reminder: newReminder)
                let reminderItem = ReminderRemoteItem(id: reminderId,
                                                      name: reminder.name,
                                                      isDone: reminder.isDone,
                                                      timeDate: fullDate,
                                                      periodicity: periodicity,
                                                      notes: reminder.notes)
                reminderService.updateReminder(with: reminderId, reminder: reminderItem)
            } else {
                //coreDataManager.addReminder(reminder: newReminder)
                let reminderItem = ReminderRemoteItem(id: UUID().uuidString,
                                                      name: name,
                                                      isDone: false,
                                                      timeDate: fullDate,
                                                      periodicity: periodicity,
                                                      notes: notes)
                reminderService.postReminder(reminder: reminderItem)
            }
            self.view?.save()
        }
    }
    
    func validName(_ name: String) -> Bool {
        var nameError: String?
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nameError = "Enter name!"
        }
        view?.update(nameError: nameError)
        return nameError?.isEmpty != false
    }
    
    func dateSwitchChanged() {
        view?.isDateSelected.toggle()
    }
    
    func timeSwitchChanged() {
        view?.isTimeSelected.toggle()
    }
    
    func updateDate(date: Date?) {
        view?.date = date
    }
    
    func updateTime(date: Date?) {
        view?.time = date
    }
    
    func getReminder() {
        if let reminderId = reminderId {
            //reminder = coreDataManager.getReminderById(reminderId: reminderId)
            //view?.showReminder(reminder: reminder)
            reminderService.getReminderDetail(with: reminderId)
        }
    }
    
}

extension CreateEditPresenter: AddEditReminderServiceDelegate {
    
    func onReminderUpdated(reminder: ReminderRemoteItem?) {
        print("reminder's updated")
    }
    
    func onNewReminderPosted(reminder: ReminderRemoteItem?) {
        print("reminder's posted")
    }
    
    func onReminderDetailFetched(reminder: ReminderRemoteItem?) {
        if let fetchedReminder = reminder {
            self.reminder = Reminder(id: fetchedReminder.id,
                                     name: fetchedReminder.name,
                                     isDone: fetchedReminder.isDone,
                                     timeDate: fetchedReminder.timeDate,
                                     periodicity: fetchedReminder.periodicity.toPeriodicity,
                                     notes: fetchedReminder.notes)
            view?.showReminder(reminder: self.reminder)
        }
    }
    
    func onError(error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
}
