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
    
    var view: MainViewProtocol
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    func getReminders() {
        let todayReminders = [Reminder(name: "Eat a cake", isDone: false, timeDate: "9:00"),
                    Reminder(name: "Do exercise", isDone: true, timeDate: "12:30", periodicity: "daily")]
        
        let weekReminders = [Reminder(name: "Go for swimming", isDone: false, timeDate: "Oct 23", periodicity: "every day"),
                    Reminder(name: "Help my brother", isDone: true, timeDate: "Oct 25"),
                    Reminder(name: "Do something", isDone: false)]
        
        let monthReminders = [Reminder(name: "Make a project", isDone: false, timeDate: "Now 4", periodicity: "every day")]
        
        let laterReminders = [Reminder(name: "Do something", isDone: false)]
        
        let data = [SectionReminders(section: Section.today.rawValue, reminders: todayReminders),
                            SectionReminders(section: Section.week.rawValue, reminders: weekReminders),
                            SectionReminders(section: Section.month.rawValue, reminders: monthReminders),
                            SectionReminders(section: Section.later.rawValue, reminders: laterReminders)]
        
        self.view.presentReminders(reminders: data)
    }
    
    func didTapReminder(reminder: Reminder) {
        print("reminder \(reminder.name)")
    }
    
    func tapOnSignInSignOut() {
        if AuthService.isAuthorized {
            self.view.move(to: .logoutUserGoToSignIn)
        } else {
            self.view.move(to: .goToSignIn)
        }
    }
}
