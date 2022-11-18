//
//  Reminderitem+ModelConvertible.swift
//  RemindersApp
//
//  Created by Андрей on 14.11.2022.
//

import Foundation

extension ReminderItem: ModelCovertible {
    
    typealias ModelType = Reminder
    
    func toModel() -> Reminder {
        let reminder = Reminder(id: self.id,
                                name: self.name,
                                isDone: self.isDone,
                                timeDate: self.timeDate,
                                isTimeSet: self.isTimeSet,
                                periodicity: self.periodicity.toPeriodicity,
                                notes: self.notes,
                                updatedAt: self.updatedAt)
        return reminder
    }
    
}
