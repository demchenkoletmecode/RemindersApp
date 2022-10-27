//
//  RemindersEndpoint.swift
//  RemindersApp
//
//  Created by Андрей on 25.10.2022.
//

import Foundation

protocol FirebaseDatabaseEndpoint {
    
    var path: String { get }
    var synced: Bool { get }
    
}

enum RemindersEndpoint: FirebaseDatabaseEndpoint {
    
    case getAllReminders
    case postReminder(String)
    case getReminderDetail(String)
    case deleteReminder(String)
    case updateReminder(String)
    
    var path: String {
        switch self {
        case .getAllReminders:
            return "\(AuthService.userId)/reminders"
        case let .postReminder(id), let .getReminderDetail(id), let .deleteReminder(id), let .updateReminder(id):
            return "\(AuthService.userId)/reminders/\(id)"
        }
    }
    
    var synced: Bool {
        switch self {
        case .getAllReminders, .getReminderDetail:
            return true
        case .postReminder, .deleteReminder, .updateReminder:
            return false
        }
    }
    
}
