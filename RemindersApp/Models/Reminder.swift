//
//  FakeUser.swift
//  RemindersApp
//
//  Created by Andrey on 10.10.2022.
//

import Foundation

struct Reminder {
    let id = UUID().uuidString
    var name: String
    var isDone: Bool
    var timeDate: Date?
    var periodicity: String?
    var notes: String?
    
    init(name: String,
         isDone: Bool,
         timeDate: Date? = nil,
         periodicity: String? = nil,
         notes: String? = nil) {
        self.name = name
        self.isDone = isDone
        self.timeDate = timeDate
        self.periodicity = periodicity
        self.notes = notes
    }
    
}

enum Periodicity: String, CaseIterable {
    case never
    case daily
    case weekly
    case monthly
    case yearly
    
    var displayValue: String {
        switch self {
        case .never:
            return "Never"
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        }
    }
}
