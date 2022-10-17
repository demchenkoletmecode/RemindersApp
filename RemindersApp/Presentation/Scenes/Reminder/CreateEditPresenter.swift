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
    var date: String { get }
    var isTimeSelected: Bool { get set }
    var time: String { get }
    var nameError: String { get set }
    
    func presentReminder(reminder: Reminder?)
    func save()
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
            self.view?.save()
        }
    }
    
    func valideName(_ name: String) -> Bool {
        if name.isEmpty {
            self.view?.nameError = "Enter name!"
        }
        return !name.isEmpty
    }
    
    func dateSwitchChanged() {
        view?.isDateSelected.toggle()
    }
    
    func timeSwitchChanged() {
        view?.isTimeSelected.toggle()
    }
    
}
