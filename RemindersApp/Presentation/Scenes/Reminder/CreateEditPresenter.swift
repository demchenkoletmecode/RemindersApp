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
    var date: Date? { get }
    var isTimeSelected: Bool { get set }
    var time: Date? { get }
    var nameError: String { get set }
    var periodicity: String? { get }
    var notes: String? { get }
    
    func presentReminder(reminder: Reminder?)
    func save(reminder: Reminder?)
    func update()
}

class CreateEditPresenter {
    
    weak var view: CreateEditProtocol?
    private var reminder: Reminder?
    var periodList = ["Never", "Daily", "Weekly", "Monthly", "Yearly"]
    
    init(view: CreateEditProtocol) {
        self.view = view
    }
    
    func tapSaveEditReminder() {
        self.view?.nameError = ""
        
        let name = view?.name ?? ""
        
        if (valideName(name)) {
            let date = view?.date
            let time = view?.time
            let period = view?.periodicity
            let notes = view?.notes
            let reminder = Reminder(name: name, isDone: false, timeDate: date, periodicity: period, notes: notes)
            
            self.view?.save(reminder: reminder)
        }
    }
    
    func valideName(_ name: String) -> Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.view?.nameError = "Enter name!"
        }
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func dateSwitchChanged() {
        view?.isDateSelected.toggle()
    }
    
    func timeSwitchChanged() {
        view?.isTimeSelected.toggle()
    }
    
}
