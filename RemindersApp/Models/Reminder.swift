//
//  FakeUser.swift
//  RemindersApp
//
//  Created by Andrey on 10.10.2022.
//

import Foundation

struct Reminder: Equatable {
    
    let id: String
    var name: String
    var isDone: Bool
    var timeDate: Date?
    var isTimeSet: Bool
    var periodicity: Periodicity?
    var notes: String?
    var updatedAt: Date
    
    init(id: String = UUID().uuidString,
         name: String,
         isDone: Bool,
         timeDate: Date? = nil,
         isTimeSet: Bool = true,
         periodicity: Periodicity? = nil,
         notes: String? = nil,
         updatedAt: Date) {
        self.id = id
        self.name = name
        self.isDone = isDone
        self.timeDate = timeDate
        self.isTimeSet = isTimeSet
        self.periodicity = periodicity
        self.notes = notes
        self.updatedAt = updatedAt
    }
    
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        return (lhs.name == rhs.name &&
                lhs.isDone == rhs.isDone &&
                lhs.timeDate == rhs.timeDate &&
                lhs.isTimeSet == rhs.isTimeSet &&
                lhs.periodicity == rhs.periodicity &&
                lhs.notes == rhs.notes)
    }
    
}

enum Periodicity: Int, CaseIterable {
    
    case never = 0
    case daily
    case weekly
    case monthly
    case yearly
    
    var displayValue: String {
        switch self {
        case .never:
            return "Never".localized
        case .daily:
            return "Daily".localized
        case .weekly:
            return "Weekly".localized
        case .monthly:
            return "Monthly".localized
        case .yearly:
            return "Yearly".localized
        }
    }

}
