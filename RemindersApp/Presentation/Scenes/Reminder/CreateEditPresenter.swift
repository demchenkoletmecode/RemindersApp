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
    var periodicity: Int? { get }
    var notes: String? { get }
    
    func showReminder(reminder: Reminder?)
    func save()
    func update(nameError: String?)
}

class CreateEditPresenter {
    
    weak var view: CreateEditProtocol?
    private var reminderId: String? = nil
    private var reminder: Reminder?
    private var fullDate: Date?
    private let calendar = Calendar.current
    private let coreDataManager = appContext.coreDateManager
    
    var periodList = Periodicity.allCases.map {
        $0.displayValue
    }
    
    init(view: CreateEditProtocol, id: String?) {
        self.view = view
        self.reminderId = id
    }
    
    func isEditReminder() -> Bool {
        return reminderId != nil
    }
    
    func tapSaveEditReminder() {
        let name = view?.name ?? ""
        if validName(name) {
            let period = view?.periodicity?.toPeriodicity
            let notes = view?.notes
            let reminder = Reminder(name: name,
                                    isDone: false,
                                    timeDate: fullDate,
                                    periodicity: period,
                                    notes: notes)
            if let reminderId = reminderId {
                coreDataManager.editReminder(id: reminderId, reminder: reminder)
            } else {
                coreDataManager.addReminder(reminder: reminder)
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
    
    func getReminder() {
        if let reminderId = reminderId {
            view?.showReminder(reminder: coreDataManager.getReminderById(reminderId: reminderId))
        }
    }
    
}
