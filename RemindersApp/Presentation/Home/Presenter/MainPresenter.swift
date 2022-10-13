//
//  MainPresenter.swift
//  RemindersApp
//
//  Created by Andrey on 06.10.2022.
//

import Foundation

enum MainViewNavigation {
    case detailsRemainder
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
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    func getReminders() {
        
        let calendar = Calendar.current
        var timeComponents1 = DateComponents()
        timeComponents1.month = 10
        timeComponents1.day = 13
        timeComponents1.hour = 9
        timeComponents1.minute = 30
        timeComponents1.year = 2022
        var timeComponents2 = DateComponents()
        timeComponents2.month = 10
        timeComponents2.day = 15
        timeComponents2.hour = 12
        timeComponents2.minute = 15
        timeComponents2.year = 2022
        var timeComponents3 = DateComponents()
        timeComponents3.month = 10
        timeComponents3.day = 13
        timeComponents3.hour = 18
        timeComponents3.minute = 00
        timeComponents3.year = 2022
        var dateComponents1 = DateComponents()
        dateComponents1.month = 10
        dateComponents1.day = 15
        dateComponents1.year = 2022
        var dateComponents2 = DateComponents()
        dateComponents2.month = 10
        dateComponents2.day = 17
        dateComponents2.year = 2022
        var dateComponents3 = DateComponents()
        dateComponents3.month = 11
        dateComponents3.day = 19
        dateComponents3.year = 2022
        
        let date1 = calendar.date(from: timeComponents1)
        let date2 = calendar.date(from: timeComponents2)
        let date3 = calendar.date(from: dateComponents1)
        let date4 = calendar.date(from: dateComponents2)
        let date5 = calendar.date(from: dateComponents3)
        let date6 = calendar.date(from: timeComponents3)
        
        let todayReminders = [Reminder(name: "Eat a cake", isDone: false, timeDate: Date()),
                    Reminder(name: "Do exercise", isDone: true, timeDate: date1, periodicity: "daily"),
                              Reminder(name: "Feed the cat", isDone: true, timeDate: date6, periodicity: "daily")]
        
        let weekReminders = [Reminder(name: "Go for swimming and don't forget to take a cap", isDone: false, timeDate: date2, periodicity: "every day"),
                    Reminder(name: "Help my brother", isDone: true, timeDate: date3)]
        
        let monthReminders = [Reminder(name: "Make a project", isDone: false, timeDate: date4, periodicity: "every day")]
        
        let laterReminders = [Reminder(name: "Do something", isDone: false),
                              Reminder(name: "Do other thing", isDone: false, timeDate: date5, periodicity: "every month")]
        
        self.reminders = todayReminders + weekReminders + monthReminders + laterReminders
        
        prepareDataSource()
    }
    
    func didTapReminder(reminder: ReminderRow?) {
        print("reminder \(reminder?.name ?? "nil")")
    }
    
    func tapOnSignInSignOut() {
        if AuthService.isAuthorized {
            self.view?.move(to: .logoutUserGoToSignIn)
        } else {
            self.view?.move(to: .goToSignIn)
        }
    }
}

private extension MainPresenter {
    
    func prepareDataSource() {
        reminders.forEach { reminder in
            if let date = reminder.timeDate {
                if date.isToday {
                    if let sectionIndex = dataSource.todayIndex {
                        appendItem(.today, sectionIndex, reminder)
                    } else {
                        appendRow(.today, reminder)
                    }
                } else if date.isWeek {
                    if let sectionIndex = dataSource.weekIndex {
                        appendItem(.week, sectionIndex, reminder)
                    }
                    else {
                        appendRow(.week, reminder)
                    }
                } else if date.isMonth {
                    if let sectionIndex = dataSource.monthIndex {
                        appendItem(.month, sectionIndex, reminder)
                    }
                    else {
                        appendRow(.month, reminder)
                    }
                } else {
                    if let sectionIndex = dataSource.laterIndex {
                        appendItem(.later, sectionIndex, reminder)
                    }
                    else {
                        appendRow(.later, reminder)
                    }
                }
            } else {
                if let sectionIndex = dataSource.laterIndex {
                    appendItem(.later, sectionIndex, reminder)
                }
                else {
                    appendRow(.later, reminder)
                }
            }
        }
        
        dataSource.sort { $0.type.displayString > $1.type.displayString }
        
        self.view?.presentReminders(reminders: dataSource)
    }
    
    func appendRow(_ type: SectionType, _ reminder: Reminder) {
        let dateString: String?
        dateString = (type == .today) ? reminder.timeDate?.timeFormat : reminder.timeDate?.dateFormat
        dataSource.append(.init(type: type, rows: [.init(name: reminder.name, isChecked: reminder.isDone, dateString: dateString, periodicityString: reminder.periodicity, objectId: reminder.id)]))
    }
    
    func appendItem(_ type: SectionType, _ sectionIndex: Array<SectionReminders>.Index, _ reminder: Reminder) {
        let dateString: String?
        dateString = (type == .today) ? reminder.timeDate?.timeFormat : reminder.timeDate?.dateFormat
        dataSource[sectionIndex].rows.append(.init(name: reminder.name, isChecked: reminder.isDone, dateString: dateString, periodicityString: reminder.periodicity, objectId: reminder.id))
    }
    
}
