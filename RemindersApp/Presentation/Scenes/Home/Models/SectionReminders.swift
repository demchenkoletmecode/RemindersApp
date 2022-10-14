//
//  SectionReminders.swift
//  RemindersApp
//
//  Created by Андрей on 11.10.2022.
//

import Foundation

enum SectionType: Int {
    
    case today = 0
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
    
}

struct SectionReminders {
    
    let type: SectionType
    var rows: [ReminderRow]
    
}

extension SectionType: Comparable {
    
    static func < (lhs: SectionType, rhs: SectionType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
}
