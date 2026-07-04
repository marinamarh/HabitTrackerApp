//
//  Habit.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 04.07.2026.
//

import Foundation
import SwiftData

@Model
class Habit {
    @Attribute(.unique) var id: UUID
    
    var title: String
    var iconName: String
    var color: String
    var frequency: HabitFrequency
    var createdAt: Date
    var isArchived: Bool
    var reminderTime: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \HabitEntry.habit) var entries: [HabitEntry] = []
    
    init(title: String, iconName: String = "checkmark.circle.fill", color: String = "34C759", frequency: HabitFrequency = .daily, reminderTime: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.iconName = iconName
        self.color = color
        self.frequency = frequency
        self.createdAt = Date()
        self.isArchived = false
        self.reminderTime = reminderTime
    }
}

extension Habit {
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return entries.contains { calendar.isDateInToday($0.date) }
    }
    
    var currentStreak: Int {
        let calendar = Calendar.current
        let completedDays = Set(entries.map { calendar.startOfDay(for: $0.date) })
        
        var streak = 0
        var dayToCheck = calendar.startOfDay(for: Date())
        
        while completedDays.contains(dayToCheck) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: dayToCheck) else { break }
            dayToCheck = previousDay
        }
        return streak
    }
}
