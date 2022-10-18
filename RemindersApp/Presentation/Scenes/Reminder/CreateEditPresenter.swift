//
//  CreateEditPresenter.swift
//  RemindersApp
//
//  Created by Андрей on 14.10.2022.
//

import Foundation

protocol CreateEditProtocol: AnyObject {
    var name: String { get }
    var isDateSelected: Bool { get set }
    var date: String? { get set }
    var isTimeSelected: Bool { get set }
    var time: String? { get set }
    var nameError: String? { get set }
    var periodicity: String? { get }
    var notes: String? { get }
    
    func presentReminder(reminder: Reminder?)
    func save(reminder: Reminder)
    func update(reminder: Reminder)
}

enum Periodicity: String {
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

class CreateEditPresenter {
    
    weak var view: CreateEditProtocol?
    private var reminder: Reminder?
    private var fullDate: Date?
    private let calendar = Calendar.current
    
    var periodList = [Periodicity.never.displayValue,
                      Periodicity.daily.displayValue,
                      Periodicity.weekly.displayValue,
                      Periodicity.monthly.displayValue,
                      Periodicity.yearly.displayValue]
    
    init(view: CreateEditProtocol) {
        self.view = view
    }
    
    func tapSaveEditReminder() {
        self.view?.nameError = ""
        
        let name = view?.name ?? ""
        
        if validName(name) {
            
//            let newItem = ReminderItem(context: contex)
//            newItem.id = reminder.id
//            newItem.name = reminder.name
//            newItem.isDone = reminder.isDone
//            newItem.timeDate = reminder.timeDate
//            newItem.periodicity = reminder.periodicity
//            newItem.notes = reminder.notes
//            do {
//                try contex.save()
//            } catch {
//
//            }
            
            let period = view?.periodicity
            let notes = view?.notes
            let reminder = Reminder(name: name, isDone: false, timeDate: fullDate, periodicity: period, notes: notes)
            
            self.view?.save(reminder: reminder)
        }
    }
    
    func validName(_ name: String) -> Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.view?.nameError = "Enter name!"
        }
        return self.view?.nameError != nil
    }
    
    func dateSwitchChanged() {
        view?.isDateSelected.toggle()
    }
    
    func timeSwitchChanged() {
        view?.isTimeSelected.toggle()
    }
    
    func updateDate(date: Date) {
        view?.date = date.dateFormat
        fullDate = calendar.date(from: date.dateComponentsFromDate)
    }
    
    func updateTime(time: Date) {
        view?.time = time.timeFormat
        fullDate = calendar.date(byAdding: time.timeComponentsFromDate, to: fullDate ?? Date())
    }
    
}
