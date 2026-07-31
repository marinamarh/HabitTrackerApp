//
//  StreakCalculatorTests.swift
//  HabitTrackerTests
//
//  Created by Marina Marhitych on 27.07.2026.
//

import Foundation
import Testing
import SwiftData
@testable import HabitTracker

struct StreakCalculatorTests {
    
    private func makeContext() throws -> ModelContext {
        let schema = Schema([Habit.self, HabitEntry.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: config)
        return ModelContext(container)
    }
    
    @Test func currentStreak_allDaysCompleted_returnsFullCount() throws {
        let context = try makeContext()
        let calendar = Calendar.current
        let habit = Habit(title: "Test", frequency: .daily)
        habit.createdAt = calendar.date(byAdding: .day, value: -4, to: .now)!
        context.insert(habit)
        
        for offset in 0..<5 {
            let day = calendar.date(byAdding: .day, value: -offset, to: .now)!
            context.insert(HabitEntry(date: day, habit: habit))
        }
        
        let streak = StreakCalculator.currentStreak(habits: [habit], calendar: calendar)
        #expect(streak == 5)
    }
    
    @Test func currentStreak_brokenYesterday_stopsAtBreak() throws {
        let context = try makeContext()
        let calendar = Calendar.current
        let habit = Habit(title: "Test", frequency: .daily)
        habit.createdAt = calendar.date(byAdding: .day, value: -2, to: .now)!
        context.insert(habit)
        
        context.insert(HabitEntry(date: .now, habit: habit))
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: .now)!
        context.insert(HabitEntry(date: twoDaysAgo, habit: habit))
        
        let streak = StreakCalculator.currentStreak(habits: [habit], calendar: calendar)
        #expect(streak == 1)
    }
    
    @Test func longestStreak_findsPastLongerStreak() throws {
        let context = try makeContext()
        let calendar = Calendar.current
        let habit = Habit(title: "Test", frequency: .daily)
        habit.createdAt = calendar.date(byAdding: .day, value: -8, to: .now)!
        context.insert(habit)
        
        for offset in 5...8 {
            let day = calendar.date(byAdding: .day, value: -offset, to: .now)!
            context.insert(HabitEntry(date: day, habit: habit))
        }
        context.insert(HabitEntry(date: .now, habit: habit))
        
        let longest = StreakCalculator.longestStreak(habits: [habit], calendar: calendar)
        #expect(longest == 4)
    }
    
    @Test func currentStreak_skipsNonScheduledDays() throws {
        let context = try makeContext()
        let calendar = Calendar.current
        let today = Weekday(date: .now)
        let habit = Habit(title: "Test", frequency: .specificDays([today]))
        context.insert(habit)
        context.insert(HabitEntry(date: .now, habit: habit))
        
        let streak = StreakCalculator.currentStreak(habits: [habit], calendar: calendar)
        #expect(streak == 1)
    }
    
    @Test func currentStreak_ignoresHabitsCreatedAfterTheDay() throws {
        let context = try makeContext()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        let oldHabit = Habit(title: "Old habit", frequency: .daily)
        oldHabit.createdAt = calendar.date(byAdding: .day, value: -9, to: today)!
        context.insert(oldHabit)
        
        for offset in 0..<10 {
            let day = calendar.date(byAdding: .day, value: -offset, to: today)!
            context.insert(HabitEntry(date: day, habit: oldHabit))
        }
        
        let newHabit = Habit(title: "New habit", frequency: .daily)
        newHabit.createdAt = today
        context.insert(newHabit)
        context.insert(HabitEntry(date: today, habit: newHabit))
        
        let streak = StreakCalculator.currentStreak(habits: [oldHabit, newHabit], calendar: calendar)
        #expect(streak == 10)
    }
    
    @Test func streaks_matchesIndividualCalculations() throws {
        let context = try makeContext()
        let calendar = Calendar.current
        let habit = Habit(title: "Test", frequency: .daily)
        habit.createdAt = calendar.date(byAdding: .day, value: -8, to: .now)!
        context.insert(habit)
        
        for offset in 5...8 {
            let day = calendar.date(byAdding: .day, value: -offset, to: .now)!
            context.insert(HabitEntry(date: day, habit: habit))
        }
        context.insert(HabitEntry(date: .now, habit: habit))
        
        let combined = StreakCalculator.streaks(habits: [habit], calendar: calendar)
        #expect(combined.current == StreakCalculator.currentStreak(habits: [habit], calendar: calendar))
        #expect(combined.longest == StreakCalculator.longestStreak(habits: [habit], calendar: calendar))
    }
}
