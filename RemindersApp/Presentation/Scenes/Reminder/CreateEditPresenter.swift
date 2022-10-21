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
    var periodicity: String? { get }
    var notes: String? { get }
    
    func showReminder(reminder: Reminder?)
    func save()
    func update(nameError: String?)
}

class CreateEditPresenter {
    
    weak var view: CreateEditProtocol?
    private var reminder: Reminder?
    private var fullDate: Date?
    private let calendar = Calendar.current
    private let contextDB = appContext.coreDateManager
    
    var periodList = Periodicity.allCases.map {
        $0.displayValue
    }
    
    init(view: CreateEditProtocol) {
        self.view = view
    }
    
    func tapSaveEditReminder(reminderId: String?) {
        let name = view?.name ?? ""
        if validName(name) {
            let period = view?.periodicity?.toPeriodicity
            let notes = view?.notes
            let reminder = Reminder(name: name,
                                    isDone: false,
                                    timeDate: fullDate,
                                    periodicity: period,
                                    notes: notes)
            if reminderId == nil {
                contextDB.addReminder(reminder: reminder)
            } else {
                contextDB.editReminder(id: reminderId!, reminder: reminder)
            }
            self.view?.save()
        }
    }
    
    func validName(_ name: String) -> Bool {
        var nameError: String?
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nameError = "Enter name!"
        }
        view?.update(nameError: nameError)
        return nameError?.isEmpty != false
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
    
    func getReminder(_ reminderId: String) {
        var reminder: Reminder?
        reminder = contextDB.getReminderById(reminderId: reminderId)
        
        view?.showReminder(reminder: reminder)
    }
    
}
