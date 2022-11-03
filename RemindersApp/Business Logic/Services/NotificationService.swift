//
//  NotificationService.swift
//  RemindersApp
//
//  Created by Андрей on 31.10.2022.
//

import Foundation
import UserNotifications

class NotificationService {
    
    func showNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { success, error in
                if success {
                    print("Permission has set")
                } else if let error = error {
                    print("An error occurred with settin notification permission: \(error.localizedDescription)")
                }
            })
    }
    
    func setNotification(reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = reminder.name
        content.sound = .default
        content.userInfo = ["REMINDER_ID": reminder.id]
        content.categoryIdentifier = "REMINDER_ISDONE_CATEGORY"
        if let notes = reminder.notes {
            content.body = notes
        }
        
        let completedAction = UNNotificationAction(identifier: "COMPLETED_ACTION",
                                                   title: "Completed",
                                                   options: UNNotificationActionOptions(rawValue: 0))
        
        let reminderCategory = UNNotificationCategory(identifier: "REMINDER_ISDONE_CATEGORY",
                                                      actions: [completedAction],
                                                      intentIdentifiers: [],
                                                      options: .customDismissAction)
        
        if let date = reminder.timeDate {
            let dateComponents = Calendar.autoupdatingCurrent.dateComponents(
                [.year, .month, .day, .hour, .minute, .second], from: date)
            
            var specificDateComponents = DateComponents()
 
            var trigger: UNNotificationTrigger
            if let period = reminder.periodicity, period != .never {
                switch period {
                case .daily:
                    // the three lines below are commented for testing repeating notifications every minute
//                    specificDateComponents = generateComponents(hour: dateComponents.hour,
//                                                                minute: dateComponents.minute,
//                                                                second: dateComponents.second)
                    specificDateComponents.second = dateComponents.second
                case .weekly:
                    specificDateComponents = generateComponents(day: dateComponents.day,
                                                                hour: dateComponents.hour,
                                                                minute: dateComponents.minute,
                                                                second: dateComponents.second)
                case .monthly:
                    specificDateComponents = generateComponents(weekOfMonth: dateComponents.weekOfMonth,
                                                                day: dateComponents.day,
                                                                hour: dateComponents.hour,
                                                                minute: dateComponents.minute,
                                                                second: dateComponents.second)

                case .yearly:
                    specificDateComponents = generateComponents(month: dateComponents.month,
                                                                weekOfMonth: dateComponents.weekOfMonth,
                                                                day: dateComponents.day,
                                                                hour: dateComponents.hour,
                                                                minute: dateComponents.minute,
                                                                second: dateComponents.second)
                case .never: break
                }
                trigger = UNCalendarNotificationTrigger(dateMatching: specificDateComponents, repeats: true)
            } else {
                specificDateComponents.hour = dateComponents.hour
                specificDateComponents.minute = dateComponents.minute
                specificDateComponents.second = dateComponents.second
                trigger = UNCalendarNotificationTrigger(dateMatching: specificDateComponents, repeats: false)
            }
            let request = UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.setNotificationCategories([reminderCategory])
            center.add(request) { (error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func generateComponents(month: Int? = nil,
                            weekOfMonth: Int? = nil,
                            day: Int? = nil,
                            hour: Int? = nil,
                            minute: Int? = nil,
                            second: Int? = nil) -> DateComponents {
        var specificDateComponents = DateComponents()
        specificDateComponents.month = month
        specificDateComponents.weekOfMonth = weekOfMonth
        specificDateComponents.day = day
        specificDateComponents.hour = hour
        specificDateComponents.minute = minute
        specificDateComponents.second = second
        return specificDateComponents
    }
    
    func editNotification(reminder: Reminder) {
        removeNotification(reminderId: reminder.id)
        setNotification(reminder: reminder)
    }
    
    func removeNotification(reminderId: String) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [reminderId])
        center.removePendingNotificationRequests(withIdentifiers: [reminderId])
    }
    
}
