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
    
    //var displayNumber
    
}

struct SectionReminders {
    
    let type: SectionType
    var rows: [ReminderRow]
    
}
