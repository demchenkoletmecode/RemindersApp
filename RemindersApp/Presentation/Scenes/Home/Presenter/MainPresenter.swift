//
//  MainPresenter.swift
//  RemindersApp
//
//  Created by Andrey on 06.10.2022.
//

import Foundation

enum MainViewNavigation {
    case detailsReminder(String)
    case createReminder
    case logoutUserGoToSignIn
    case goToSignIn
}

protocol MainViewProtocol: AnyObject {
    func presentReminders(reminders: [SectionReminders])
    func move(to: MainViewNavigation)
    func changeBackground(indexPath: IndexPath)
}

class MainPresenter {
    
    weak var view: MainViewProtocol?
    private var reminders: [Reminder] = []
    private var dataSource = [SectionReminders]()
    private let reminderService: ReminderService
    private let notificationManager = appContext.notificationManager
    private let storage: ReminderRepository
    
    init(view: MainViewProtocol,
         reminderService: ReminderService,
         storage: ReminderRepository) {
        self.view = view
        self.reminderService = reminderService
        self.storage = storage
    }
    
    func getReminders() {
        reminders.removeAll()
        dataSource.removeAll()
        var localReminders = [Reminder]()
        var remoteReminders = [Reminder]()
        storage.getAllReminders { result in
            switch result {
            case let .success(reminders):
                localReminders = reminders
                self.reminders = localReminders
            case let .failure(error):
                print("An error occurred with getting local items: \(error.localizedDescription)")
            }
        }
        let group = DispatchGroup()
        group.enter()
        reminderService.getAllReminders { result in
            switch result {
            case let .success(reminders):
                remoteReminders = reminders.map { rem in
                    Reminder(id: rem.id,
                             name: rem.name,
                             isDone: rem.isDone,
                             timeDate: rem.timeDate,
                             isTimeSet: rem.isTimeSet,
                             periodicity: rem.periodicity.toPeriodicity,
                             notes: rem.notes,
                             updatedAt: rem.updatedAt)
                }
            case let .failure(error):
                print("An error occurred with getting remote items: \(error.localizedDescription)")
            }
            group.leave()
        }
        group.notify(queue: .global(qos: .default)) { [weak self] in
            self?.checkChanges(localReminders: localReminders, remoteReminders: remoteReminders)
        }
        prepareDataSource()
    }
    
    func didTapReminder(reminderId: String) {
        self.view?.move(to: .detailsReminder(reminderId))
    }
    
    func tapOnSignInSignOut() {
        if AuthService.isAuthorized {
            reminders.forEach {
                storage.deleteReminder(object: $0, completion: { error in
                    if let error = error {
                        print("An error occurred with changing accomp in local reminder: \(error.localizedDescription)")
                    }
                })
                notificationManager.removeNotification(reminderId: $0.id)
            }
            self.view?.move(to: .logoutUserGoToSignIn)
        } else {
            self.view?.move(to: .goToSignIn)
        }
    }
    
    func tapAddReminder() {
        self.view?.move(to: .createReminder)
    }
    
    func highlightReminder(_ id: String) {
        let comparator: (ReminderRow) -> Bool = {
            $0.objectId == id
        }
        if let sectionIndex = dataSource.firstIndex(where: { $0.rows.contains(where: comparator) }),
           let rowIndex = dataSource[sectionIndex].rows.firstIndex(where: comparator) {
            let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
            DispatchQueue.main.async {
                self.view?.changeBackground(indexPath: indexPath)
            }
        }
    }
    
    func didTapAccomplishment(reminderId: String) {
        if let reminder = reminders.first(where: { $0.id == reminderId }) {
            if let periodicity = reminder.periodicity, periodicity != .never {
                let date = reminder.timeDate?.addPeriodDate(index: periodicity.rawValue)
                let reminderItem = Reminder(id: reminder.id,
                                            name: reminder.name,
                                            isDone: reminder.isDone,
                                            timeDate: date,
                                            isTimeSet: reminder.isTimeSet,
                                            periodicity: reminder.periodicity,
                                            notes: reminder.notes,
                                            updatedAt: Date())
                
                notificationManager.editNotification(reminder: reminderItem)
                updateLocalReminder(reminderItem)
                updateRemoteReminder(reminderItem)
                getReminders()
            } else {
                let updatedReminder = changeReminderAccomplishment(reminder)
                storage.changeAccomplishment(object: updatedReminder, completion: { error in
                    if let error = error {
                        print("An error occurred with changing accomp in local reminder: \(error.localizedDescription)")
                    }
                })

                if !reminder.isDone {
                    notificationManager.removeNotification(reminderId: reminderId)
                } else {
                    notificationManager.editNotification(reminder: reminder)
                }
                
                let reminderItem = ReminderRemoteItem(id: reminderId,
                                                      name: reminder.name,
                                                      isDone: !reminder.isDone,
                                                      timeDate: reminder.timeDate,
                                                      isTimeSet: reminder.isTimeSet,
                                                      periodicity: reminder.periodicity?.rawValue ?? -1,
                                                      notes: reminder.notes,
                                                      updatedAt: Date())
                reminderService.updateReminder(with: reminderId, reminder: reminderItem) { [weak self] result in
                    switch result {
                    case let .success(id):
                        print("reminder with id = \(id) has updated")
                        self?.getReminders()
                    case let .failure(error):
                        print("An error occurred with changing accomplishment: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func changeReminderAccomplishment(_ reminder: Reminder) -> Reminder {
        var reminderItem = reminder
        var date = reminderItem.timeDate
        let updatedAt = Date()
        var isEdit = false
        if !reminderItem.isDone, let period = reminderItem.periodicity, period != .never {
            date = reminderItem.timeDate?.addPeriodDate(index: period.rawValue)
            isEdit = true
        }
        reminderItem.timeDate = date
        if isEdit {
            reminderItem.isDone = false
            appContext.notificationManager.editNotification(reminder: reminderItem)
        } else {
            reminderItem.isDone.toggle()
            appContext.notificationManager.removeNotification(reminderId: reminderItem.id)
        }
  
        return reminderItem
    }
    
}

private extension MainPresenter {
    
    func prepareDataSource() {
        reminders.sort { $0.timeDate ?? $0.updatedAt < $1.timeDate ?? $0.updatedAt }
        reminders.forEach { reminder in
            let sectionType: SectionType
            if let date = reminder.timeDate {
                if date.isToday {
                    sectionType = .today
                } else if date.isWeek {
                    sectionType = .week
                } else if date.isMonth {
                    sectionType = .month
                } else {
                    sectionType = .later
                }
            } else {
                sectionType = .later
            }
            appendItem(sectionType: sectionType, reminder: reminder)
        }
        
        dataSource.sort { $0.type < $1.type }
        self.view?.presentReminders(reminders: dataSource)
    }
    
    func appendItem(sectionType: SectionType, reminder: Reminder) {
        let timeForCell = reminder.timeDate?.timeFormatForCell
        let dateForCell = reminder.timeDate?.dateFormatForCell
        let dateString = sectionType == .today && reminder.isTimeSet ? timeForCell : dateForCell
        var periodicityStr = reminder.periodicity?.displayValue
        if let periodicity = reminder.periodicity, periodicity == .never {
            periodicityStr = nil
        }
        let rowItem = ReminderRow(name: reminder.name,
                                  isChecked: reminder.isDone,
                                  dateString: dateString,
                                  periodicityString: periodicityStr,
                                  objectId: reminder.id)
        if let sectionIndex = dataSource.firstIndex(where: { $0.type == sectionType }) {
            dataSource[sectionIndex].rows.append(rowItem)
        } else {
            let section = SectionReminders(type: sectionType, rows: [rowItem])
            dataSource.append(section)
        }
    }
    
    func checkChanges(localReminders: [Reminder], remoteReminders: [Reminder]) {
        for remRem in remoteReminders {
            if let locRem = localReminders.first(where: { $0.id == remRem.id }) {
                if remRem != locRem {
                    if remRem.updatedAt > locRem.updatedAt {
                        updateLocalReminder(remRem)
                        let index = localReminders.firstIndex(where: { $0.id == remRem.id })
                        if let index = index {
                            reminders[index] = remRem
                        }
                    } else if remRem.updatedAt < locRem.updatedAt {
                        updateRemoteReminder(locRem)
                    }
                }
            } else {
                addLocalReminder(remRem)
                reminders.append(remRem)
            }
        }
        for locRem in localReminders where !remoteReminders.contains(where: { $0.id == locRem.id }) {
            addRemoteReminder(locRem)
        }
        dataSource.removeAll()
        prepareDataSource()
    }
    
    func updateLocalReminder(_ reminder: Reminder) {
        storage.updateReminder(object: reminder, completion: { error in
            if let error = error {
                print("An error occurred with updating local reminder: \(error.localizedDescription)")
            }
        })
        notificationManager.editNotification(reminder: reminder)
    }
    
    func addLocalReminder(_ reminder: Reminder) {
        storage.createReminder(object: reminder, completion: { error in
            if let error = error {
                print("An error occurred with creating local reminder: \(error.localizedDescription)")
            }
        })
        notificationManager.setNotification(reminder: reminder)
    }
    
    func updateRemoteReminder(_ reminder: Reminder) {
        let reminderItem = ReminderRemoteItem(id: reminder.id,
                                              name: reminder.name,
                                              isDone: reminder.isDone,
                                              timeDate: reminder.timeDate,
                                              isTimeSet: reminder.isTimeSet,
                                              periodicity: reminder.periodicity?.rawValue ?? -1,
                                              notes: reminder.notes,
                                              updatedAt: reminder.updatedAt)
        reminderService.updateReminder(with: reminder.id, reminder: reminderItem) { result in
            switch result {
            case let .success(id):
                print("reminder with id = \(id) has updated")
            case let .failure(error):
                print("An error occurred with updating remote item: \(error.localizedDescription)")
            }
        }
    }
    
    func addRemoteReminder(_ reminder: Reminder) {
        if !AuthService.userId.isEmpty {
            let reminderItem = ReminderRemoteItem(id: reminder.id,
                                                  name: reminder.name,
                                                  isDone: reminder.isDone,
                                                  timeDate: reminder.timeDate,
                                                  isTimeSet: reminder.isTimeSet,
                                                  periodicity: reminder.periodicity?.rawValue ?? -1,
                                                  notes: reminder.notes,
                                                  updatedAt: reminder.updatedAt)
            reminderService.postReminder(reminder: reminderItem) { result in
                switch result {
                case let .success(id):
                    print("reminder with id = \(id) has created")
                case let .failure(error):
                    print("An error occurred with post item: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
