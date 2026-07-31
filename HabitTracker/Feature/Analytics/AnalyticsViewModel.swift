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
            let count = entries.filter { $0.date == day }.count
            return DailyCompletion(date: day, completedCount: count)
        }
    }
}
