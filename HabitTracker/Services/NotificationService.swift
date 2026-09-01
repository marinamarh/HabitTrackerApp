//
//  NotificationService.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 05.08.2026.
//

import UserNotifications

@Observable
final class NotificationService {
    
    private(set) var permission: NotificationPermission = .notDetermined
    
    private let center = UNUserNotificationCenter.current()
    
    func refreshPermission() async {
        let status = await center.notificationSettings().authorizationStatus
        permission = NotificationPermission(status)
    }
    
    func requestAuthorization() async throws {
        let isGranted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
        permission = isGranted ? .authorized : .denied
    }
    
    func scheduleReminder(for habit: Habit) async {
        cancelReminder(for: habit)
        
        guard let reminderTime = habit.reminderTime else { return }
        
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        
        let content = UNMutableNotificationContent()
        content.title = habit.title
        content.body = String(
            localized: "Time to \(habit.title.lowercased())",
            comment: "Notification reminding the user to do a habit, e.g. 'Time to read'"
        )
        content.sound = .default
        
        switch habit.frequency {
        case .daily:
            let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: true)
            let request = UNNotificationRequest(identifier: identifier(for: habit), content: content, trigger: trigger)
            await add(request)
            
        case .specificDays(let days):
            for day in days {
                var components = timeComponents
                components.weekday = day.calendarWeekday
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: identifier(for: habit, weekday: day), content: content, trigger: trigger)
                await add(request)
            }
        }
    }
    
    func cancelReminder(for habit: Habit) {
        let allPossibleIdentifiers = [identifier(for: habit)] + Weekday.allCases.map { identifier(for: habit, weekday: $0) }
        center.removePendingNotificationRequests(withIdentifiers: allPossibleIdentifiers)
    }
    
    private func add(_ request: UNNotificationRequest) async {
        do {
            try await center.add(request)
        } catch {
            print("Failed to schedule reminder \(request.identifier): \(error)")
        }
    }
    
    private func identifier(for habit: Habit, weekday: Weekday? = nil) -> String {
        guard let weekday else { return habit.id.uuidString }
        return "\(habit.id.uuidString)-\(weekday.rawValue)"
    }
}
