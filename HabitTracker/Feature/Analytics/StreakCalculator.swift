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
    
    static func streaks(habits: [Habit], calendar: Calendar = .current) -> (current: Int, longest: Int) {
        let completed = completedDays(for: habits, calendar: calendar)
        return (
            current: currentStreak(habits: habits, completedDays: completed, calendar: calendar),
            longest: longestStreak(habits: habits, completedDays: completed, calendar: calendar)
        )
    }
    
    static func currentStreak(habits: [Habit], calendar: Calendar = .current) -> Int {
        currentStreak(habits: habits, completedDays: completedDays(for: habits, calendar: calendar), calendar: calendar)
    }
    
    static func longestStreak(habits: [Habit], calendar: Calendar = .current) -> Int {
        longestStreak(habits: habits, completedDays: completedDays(for: habits, calendar: calendar), calendar: calendar)
    }
    
    private static func completedDays(for habits: [Habit], calendar: Calendar) -> [UUID: Set<Date>] {
        Dictionary(uniqueKeysWithValues: habits.map { habit in
            let days = Set(habit.entries.map { calendar.startOfDay(for: $0.date) })
            return (habit.id, days)
        })
    }
    
    private static func dayStatus(
        _ day: Date,
        habits: [Habit],
        completedDays: [UUID: Set<Date>],
        calendar: Calendar
    ) -> DayStatus {
        let scheduledHabits = habits.filter { habit in
            let createdDay = calendar.startOfDay(for: habit.createdAt)
            return habit.isScheduled(on: day) && createdDay <= day
        }
        guard !scheduledHabits.isEmpty else { return .notScheduled }
        
        let allCompleted = scheduledHabits.allSatisfy { habit in
            completedDays[habit.id]?.contains(day) ?? false
        }
        return allCompleted ? .completed : .incomplete
    }
    
    private static func currentStreak(
        habits: [Habit],
        completedDays: [UUID: Set<Date>],
        calendar: Calendar
    ) -> Int {
        guard let earliest = completedDays.values.flatMap({ $0 }).min() else { return 0 }
        
        var streak = 0
        let today = calendar.startOfDay(for: .now)
        var day = today
        
        while day >= earliest {
            switch dayStatus(day, habits: habits, completedDays: completedDays, calendar: calendar) {
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
    
    private static func longestStreak(
        habits: [Habit],
        completedDays: [UUID: Set<Date>],
        calendar: Calendar
    ) -> Int {
        guard let earliest = completedDays.values.flatMap({ $0 }).min() else { return 0 }
        
        var longest = 0
        var current = 0
        var day = earliest
        let today = calendar.startOfDay(for: .now)
        
        while day <= today {
            switch dayStatus(day, habits: habits, completedDays: completedDays, calendar: calendar) {
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
