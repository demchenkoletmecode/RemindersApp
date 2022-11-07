//
//  Date.swift
//  RemindersApp
//
//  Created by Андрей on 12.10.2022.
//

import Foundation

extension Date {
    
    var dateFormatForCell: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
    
    var timeFormatForCell: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: self)
    }
    
    var dateFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd / MM / yyyy"
        return dateFormatter.string(from: self)
    }
    
    var timeFormat: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH : mm"
        return timeFormatter.string(from: self)
    }
    
    var dateComponentsFromDate: DateComponents {
        Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: self)
    }
    
    var timeComponentsFromDate: DateComponents {
        Calendar.current.dateComponents([.hour, .minute], from: self)
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
    
    func addPeriodDate(index: Int) -> Date {
        var dateComponent = DateComponents()
        switch index {
        case 1:
            dateComponent.day = 1
            return Calendar.current.date(byAdding: dateComponent, to: self) ?? self
        case 2:
            dateComponent.weekOfYear = 1
            return Calendar.current.date(byAdding: dateComponent, to: self) ?? self
        case 3:
            dateComponent.month = 1
            return Calendar.current.date(byAdding: dateComponent, to: self) ?? self
        case 4:
            dateComponent.year = 1
            return Calendar.current.date(byAdding: dateComponent, to: self) ?? self
        default:
            return self
        }
    }
    
}
