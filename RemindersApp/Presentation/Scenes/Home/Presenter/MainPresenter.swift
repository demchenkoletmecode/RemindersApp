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
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    func getReminders() {
        reminders.removeAll()
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
        
        let todayReminders = [Reminder(name: "Eat a cake",
                                       isDone: false,
                                       timeDate: Date()),
                              Reminder(name: "Do exercise",
                                       isDone: true,
                                       timeDate: date1,
                                       periodicity: .daily),
                              Reminder(name: "Feed the cat",
                                       isDone: true,
                                       timeDate: date6,
                                       periodicity: .daily)]
        
        let weekReminders = [Reminder(name: "Go for swimming and don't forget to take a cap",
                                      isDone: false,
                                      timeDate: date2,
                                      periodicity: .weekly),
                             Reminder(name: "Help my brother",
                                      isDone: true,
                                      timeDate: date3)]
        
        let monthReminders = [Reminder(name: "Make a project",
                                       isDone: false, timeDate: date4, periodicity: .monthly)]
        
        let laterReminders = [Reminder(name: "Do something", isDone: false),
                              Reminder(name: "Do other thing", isDone: false,
                                       timeDate: date5,
                                       periodicity: .yearly)]
        
        self.reminders = todayReminders + weekReminders + monthReminders + laterReminders
        
        prepareDataSource()
        self.view?.presentReminders(reminders: dataSource)
    }
    
    func addReminder(item: ReminderItem) {
        
        reminders.append(Reminder(name: item.name,
                                  isDone: item.isDone,
                                  timeDate: item.timeDate,
                                  periodicity: item.periodicity?.toPeriodicity,
                                  notes: item.notes))
    }
    
    func didTapReminder(reminderId: String) {
        print("reminder id = \(reminderId)")
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
