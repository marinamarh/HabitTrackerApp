//
//  StreakCalculator.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 27.07.2026.
//

import Foundation

struct StreakCalculator {

    enum DayStatus {
        case completed
        case incomplete
        case notScheduled
    }
    
    private static func dayStatus(_ day: Date, habits: [Habit], calendar: Calendar) -> DayStatus {
        let scheduledHabits = habits.filter { $0.isScheduled(on: day) }
        guard !scheduledHabits.isEmpty else { return .notScheduled }
        
        let allCompleted = scheduledHabits.allSatisfy { habit in
            habit.entries.contains { calendar.isDate($0.date, inSameDayAs: day) }
        }
        return allCompleted ? .completed : .incomplete
    }
    
    static func currentStreak(habits: [Habit], calendar: Calendar = .current) -> Int {
        let allDates = habits.flatMap(\.entries).map { calendar.startOfDay(for: $0.date) }
        guard let earliest = allDates.min() else { return 0 }
        
        var streak = 0
        let today = calendar.startOfDay(for: .now)
        var day = today
        
        while day >= earliest {
            switch dayStatus(day, habits: habits, calendar: calendar) {
            case .completed:
                streak += 1
            case .incomplete:
                if day != today {
                    return streak
                }
            case .notScheduled:
                break
            }
            
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        
        return streak
    }
    
    static func longestStreak(habits: [Habit], calendar: Calendar = .current) -> Int {
        let allDates = habits.flatMap(\.entries).map { calendar.startOfDay(for: $0.date) }
        guard let earliest = allDates.min() else { return 0 }
        
        var longest = 0
        var current = 0
        var day = earliest
        let today = calendar.startOfDay(for: .now)
        
        while day <= today {
            switch dayStatus(day, habits: habits, calendar: calendar) {
            case .completed:
                current += 1
                longest = max(longest, current)
            case .incomplete:
                current = 0
            case .notScheduled:
                break
            }
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
        return longest
    }
}
