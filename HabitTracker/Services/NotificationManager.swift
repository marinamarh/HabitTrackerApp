//
//  NotificationManager.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 05.08.2026.
//


import Foundation
import UserNotifications

enum NotificationManager {

    static func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    static func authorizationStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    static func scheduleReminder(for habit: Habit) {
        cancelReminder(for: habit) // avoid duplicate/stale requests when time or frequency changes

        guard let reminderTime = habit.reminderTime else { return }

        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)

        let content = UNMutableNotificationContent()
        content.title = habit.title
        content.body = "Time to \(habit.title.lowercased())"
        content.sound = .default

        switch habit.frequency {
        case .daily:
            let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: true)
            let request = UNNotificationRequest(identifier: identifier(for: habit), content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)

        case .specificDays(let days):
            for day in days {
                var components = timeComponents
                components.weekday = day.calendarWeekday
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: identifier(for: habit, weekday: day), content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }

    static func cancelReminder(for habit: Habit) {
        let allPossibleIdentifiers = [identifier(for: habit)] + Weekday.allCases.map { identifier(for: habit, weekday: $0) }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: allPossibleIdentifiers)
    }

    private static func identifier(for habit: Habit, weekday: Weekday? = nil) -> String {
        guard let weekday else { return habit.id.uuidString }
        return "\(habit.id.uuidString)-\(weekday.rawValue)"
    }
}
