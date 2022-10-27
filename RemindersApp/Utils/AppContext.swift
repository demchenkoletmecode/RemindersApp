//
//  AppContext.swift
//  RemindersApp
//
//  Created by Andrey on 07.10.2022.
//

import Foundation

let appContext = AppContext()

class AppContext {
    fileprivate init() {}

    lazy var authentication = AuthService()
    
    lazy var firebaseDatabase = ReminderService()
    
    lazy var coreDateManager = CoreDataManager()
    
    lazy var userId = UUID().uuidString
}
