//
//  AnalyticsViewModel.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 31.07.2026.
//

import Foundation

struct AnalyticsViewModel {
    static func weeklyData(from entries: [HabitEntry], calendar: Calendar = .current) -> [DailyCompletion] {
        let today = calendar.startOfDay(for: .now)
        
        let last7Days = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }.reversed()
        
        return last7Days.map { day in
            let count = entries.filter { calendar.isDate($0.date, inSameDayAs: day) }.count
            return DailyCompletion(date: day, completedCount: count)
        }
    }
    
    static func completionPercentage(habits: [Habit], daysBack: Int, calendar: Calendar = .current) -> Int {
        let today = calendar.startOfDay(for: .now)
        guard let startDate = calendar.date(byAdding: .day, value: -(daysBack - 1), to: today) else {
            return 0
        }
        
        let completedDatesByHabit = Dictionary(uniqueKeysWithValues: habits.map { habit in
            (habit.id, Set(habit.entries.map { calendar.startOfDay(for: $0.date) }))
        })
        
        var scheduledCount = 0
        var completedCount = 0
        
        var day = startDate
        while day <= today {
            for habit in habits {
                let createdDay = calendar.startOfDay(for: habit.createdAt)
                guard createdDay <= day, habit.isScheduled(on: day) else { continue }
                
                scheduledCount += 1
                if completedDatesByHabit[habit.id]?.contains(day) == true {
                    completedCount += 1
                }
            }
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = nextDay
        }
        
        guard scheduledCount > 0 else { return 0 }
        return Int((Double(completedCount) / Double(scheduledCount) * 100).rounded())
    }
}
