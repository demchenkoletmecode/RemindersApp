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
    
    init(name: String,
         isDone: Bool,
         timeDate: Date? = nil,
         periodicity: String? = nil) {
        self.name = name
        self.isDone = isDone
        self.timeDate = timeDate
        self.periodicity = periodicity
    }
    
}
