//
//  Array.swift
//  RemindersApp
//
//  Created by Андрей on 13.10.2022.
//

import Foundation

extension Array where Element == SectionReminders {
    
    var todayIndex: Array<SectionReminders>.Index? {
        self.firstIndex(where: { $0.type == .today })
    }
    
    var weekIndex: Array<SectionReminders>.Index? {
        self.firstIndex(where: { $0.type == .week })
    }
    
    var monthIndex: Array<SectionReminders>.Index? {
        self.firstIndex(where: { $0.type == .month })
    }
    
    var laterIndex: Array<SectionReminders>.Index? {
        self.firstIndex(where: { $0.type == .later })
    }
    
}
