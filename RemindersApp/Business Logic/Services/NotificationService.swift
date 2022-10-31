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
        content.body = reminder.notes ?? ""
        content.sound = .default
        
        if let date = reminder.timeDate {
            let dateComponents = Calendar.autoupdatingCurrent.dateComponents(
                [.year, .month, .day, .hour, .minute, .second], from: date)
            
            var dateComponent = DateComponents()
            dateComponent.hour = dateComponents.hour
            dateComponent.minute = dateComponents.minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
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
    
   /* private func notificationHasExpired(dueDate: DateComponents) -> Bool {
        return Calendar.current.date(from: DateComponents(year: dueDate.year,
                                                          month: dueDate.month,
                                                          day: dueDate.day,
                                                          hour: dueDate.hour,
                                                          minute: dueDate.minute))?.timeIntervalSinceNow.sign == .minus
    }*/

}
