//
//  String.swift
//  RemindersApp
//
//  Created by Андрей on 20.10.2022.
//

import Foundation

extension String? {
    
    var toPeriodicity: Periodicity? {
        var periodicity: Periodicity?
        if let period = self {
            periodicity = Periodicity(rawValue: period)
        }
        return periodicity
    }
    
}
