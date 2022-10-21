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
    private let context = appContext.coreDateManager
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    func getReminders() {
        reminders.removeAll()
        dataSource.removeAll()
        reminders = context.fetchReminders()
        
        prepareDataSource()
        self.view?.presentReminders(reminders: dataSource)
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
        context.changeAccomplishment(id: reminderId)
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
    }
    
    func appendItem(sectionType: SectionType, reminder: Reminder) {
        let dateString = sectionType == .today ? reminder.timeDate?.timeFormatForCell : reminder.timeDate?.dateFormatForCell
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
    
}
