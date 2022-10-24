//
//  Int+Ext.swift
//  RemindersApp
//
//  Created by Андрей on 21.10.2022.
//

import Foundation

extension Int {
    
    var toPeriodicity: Periodicity? {
        return Periodicity(rawValue: self)
    }
    
}
