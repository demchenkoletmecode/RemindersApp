//
//  FakeUser.swift
//  RemindersApp
//
//  Created by Andrey on 10.10.2022.
//

import Foundation

class Reminder {
    var name: String
    var isDone: Bool
    var timeDate: String?
    var periodicity: String?
    
    init(name: String, isDone: Bool, timeDate: String? = nil, periodicity: String? = nil) {
        self.name = name
        self.isDone = isDone
        self.timeDate = timeDate
        self.periodicity = periodicity
    }
}

class SectionReminders {
    var section: String?
    var reminders: [Reminder]?
    
    init(section: String, reminders: [Reminder]) {
        self.section = section
        self.reminders = reminders
    }
}

enum Section: String {
    case today = "Today"
    case week = "This week"
    case month = "This month"
    case later = "Later"
}
