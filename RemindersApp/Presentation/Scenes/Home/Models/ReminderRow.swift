//
//  Te.swift
//  RemindersApp
//
//  Created by Андрей on 12.10.2022.
//

import Foundation

struct ReminderRow {
    
    let name: String
    var isChecked: Bool
    let dateString: String?
    let periodicityString: String?
    let objectId: String
    
    mutating func changeAccomplishment() {
        self.isChecked = !self.isChecked
    }
}
