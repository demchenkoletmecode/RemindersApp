//
//  Date.swift
//  RemindersApp
//
//  Created by Андрей on 12.10.2022.
//

import Foundation

extension Date {
    
    var dateFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
    
    var timeFormat: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: self)
    }
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    var isMonth: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
}
