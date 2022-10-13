//
//  SectionReminders.swift
//  RemindersApp
//
//  Created by Андрей on 11.10.2022.
//

import Foundation

enum SectionType {
    
    case today
    case week
    case month
    case later
    
    var displayString: String {
        switch self {
        case .today:
            return "Today"
        case .week:
            return "This week"
        case .month:
            return "This month"
        case .later:
            return "Later"
        }
    }
    
    var sectionNumber: Int {
        switch self {
        case .today:
            return 1
        case .week:
            return 2
        case .month:
            return 3
        case .later:
            return 4
        }
    }
    
}

struct SectionReminders {
    
    let type: SectionType
    var rows: [ReminderRow]
    
}
