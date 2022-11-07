//
//  String.swift
//  RemindersApp
//
//  Created by Андрей on 20.10.2022.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var isPasswordHasNumberAndCharacter: Bool {
        let passRegEx = "^(?=.*[a-z])(?=.*[0-9]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    var toPeriodicity: Periodicity? {
       Periodicity.allCases.first(where: {
          $0.displayValue == self
       })
    }
    
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd / MM / yyyy"
        let date = dateFormatter.date(from: self)
        return date ?? Date()
    }
    
    var timeToDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: self)
        return date
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
}
