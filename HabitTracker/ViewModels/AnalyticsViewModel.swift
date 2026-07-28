//
//  AnalyticsViewModel.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 20.07.2026.
//


import Foundation
import Observation

@Observable
final class AnalyticsViewModel {
    private(set) var weeklyData: [DailyCompletion] = []
    private(set) var currentStreak: Int = 0
    private(set) var longestStreak: Int = 0
    
    func loadWeeklyData(from entries: [HabitEntry]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        let last7Days = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }.reversed()
        
        weeklyData = last7Days.map { day in
            let count = entries.filter { $0.date == day }.count
            return DailyCompletion(date: day, completedCount: count)
        }
    }
    
    func loadStreaks(from habits: [Habit]) {
        currentStreak = StreakCalculator.currentStreak(habits: habits)
        longestStreak = StreakCalculator.longestStreak(habits: habits)
    }
}
