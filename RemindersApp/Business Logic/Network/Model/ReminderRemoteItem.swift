//
//  ReminderRemoteItem.swift
//  RemindersApp
//
//  Created by Андрей on 25.10.2022.
//

import Foundation

struct ReminderRemoteItem: Codable {
    let id: String
    var name: String
    var isDone: Bool
    var timeDate: Date?
    var periodicity: Int
    var notes: String?
    var updatedAt: Date
}
