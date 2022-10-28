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
}

class MainPresenter {
    
    weak var view: MainViewProtocol?
    private var reminders: [Reminder] = []
    private var dataSource = [SectionReminders]()
    private let coreDataManager = appContext.coreDateManager
    private let reminderService: ReminderService
    
    init(view: MainViewProtocol, reminderService: ReminderService) {
        self.view = view
        self.reminderService = reminderService
    }
    
    func getReminders() {
        reminders.removeAll()
        dataSource.removeAll()
        let localReminders = coreDataManager.fetchReminders()
        var remoteReminders = [Reminder]()
        reminders = localReminders
        checkChanges(localReminders: localReminders, remoteReminders: remoteReminders)
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
                             periodicity: rem.periodicity.toPeriodicity,
                             notes: rem.notes,
                             updatedAt: rem.updatedAt)
                }
            case let .failure(error):
                print("An error occurred with getting items: \(error.localizedDescription)")
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
            self.view?.move(to: .logoutUserGoToSignIn)
        } else {
            self.view?.move(to: .goToSignIn)
        }
    }
    
    func tapAddReminder() {
        self.view?.move(to: .createReminder)
    }
    
    func didTapAccomplishment(reminderId: String) {
        coreDataManager.changeAccomplishment(id: reminderId)
        if let reminder = reminders.first(where: { $0.id == reminderId }) {
            let reminderItem = ReminderRemoteItem(id: reminderId,
                                                  name: reminder.name,
                                                  isDone: !reminder.isDone,
                                                  timeDate: reminder.timeDate,
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

private extension MainPresenter {
    
    func prepareDataSource() {
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
        let dateString = sectionType == .today ? timeForCell : dateForCell
        let rowItem = ReminderRow(name: reminder.name,
                                  isChecked: reminder.isDone,
                                  dateString: dateString,
                                  periodicityString: reminder.periodicity?.displayValue,
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
        coreDataManager.editReminder(id: reminder.id, reminder: reminder)
    }
    
    func addLocalReminder(_ reminder: Reminder) {
        coreDataManager.addReminder(reminder: reminder)
    }
    
    func updateRemoteReminder(_ reminder: Reminder) {
        let reminderItem = ReminderRemoteItem(id: reminder.id,
                                              name: reminder.name,
                                              isDone: reminder.isDone,
                                              timeDate: reminder.timeDate,
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
