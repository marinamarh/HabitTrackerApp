//
//  AnalyticsViewModelTests.swift
//  HabitTrackerTests
//
//  Created by Marina Marhitych on 31.07.2026.
//

import Foundation
import Testing
import SwiftData
@testable import HabitTracker

struct AnalyticsViewModelTests {

    private func makeContext() throws -> ModelContext {
        let schema = Schema([Habit.self, HabitEntry.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: config)
        return ModelContext(container)
    }

    @Test func completionPercentage_allDaysCompleted_returns100() throws {
        let context = try makeContext()
        let calendar = Calendar.current
        let habit = Habit(title: "Habit A", frequency: .daily)
        habit.createdAt = calendar.date(byAdding: .day, value: -4, to: .now)!
        context.insert(habit)

        for offset in 0..<5 {
            let day = calendar.date(byAdding: .day, value: -offset, to: .now)!
            context.insert(HabitEntry(date: day, habit: habit))
        }

        let pct = AnalyticsViewModel.completionPercentage(habits: [habit], daysBack: 7, calendar: calendar)
        #expect(pct == 100)
    }

    @Test func completionPercentage_partialCompletion_roundsCorrectly() throws {
        let context = try makeContext()
        let calendar = Calendar.current
        let habit = Habit(title: "Habit B", frequency: .daily)
        habit.createdAt = calendar.date(byAdding: .day, value: -6, to: .now)!
        context.insert(habit)

        for offset in [0, 2, 5] {
            let day = calendar.date(byAdding: .day, value: -offset, to: .now)!
            context.insert(HabitEntry(date: day, habit: habit))
        }

        let pct = AnalyticsViewModel.completionPercentage(habits: [habit], daysBack: 7, calendar: calendar)
        #expect(pct == 43)
    }

    @Test func completionPercentage_combinesMultipleHabits() throws {
        let context = try makeContext()
        let calendar = Calendar.current

        let habitA = Habit(title: "Habit A", frequency: .daily)
        habitA.createdAt = calendar.date(byAdding: .day, value: -4, to: .now)!
        context.insert(habitA)
        for offset in 0..<5 {
            let day = calendar.date(byAdding: .day, value: -offset, to: .now)!
            context.insert(HabitEntry(date: day, habit: habitA))
        }

        let habitB = Habit(title: "Habit B", frequency: .daily)
        habitB.createdAt = calendar.date(byAdding: .day, value: -6, to: .now)!
        context.insert(habitB)
        for offset in [0, 2, 5] {
            let day = calendar.date(byAdding: .day, value: -offset, to: .now)!
            context.insert(HabitEntry(date: day, habit: habitB))
        }

        let pct = AnalyticsViewModel.completionPercentage(habits: [habitA, habitB], daysBack: 7, calendar: calendar)
        #expect(pct == 67)
    }

    @Test func completionPercentage_noHabits_returnsZeroWithoutCrashing() throws {
        let calendar = Calendar.current
        let pct = AnalyticsViewModel.completionPercentage(habits: [], daysBack: 7, calendar: calendar)
        #expect(pct == 0)
    }

    @Test func completionPercentage_habitCreatedToday_onlyCountsFromCreationDay() throws {
        let context = try makeContext()
        let calendar = Calendar.current
        let habit = Habit(title: "Brand New", frequency: .daily)
        habit.createdAt = .now
        context.insert(habit)
        context.insert(HabitEntry(date: .now, habit: habit))

        let pct = AnalyticsViewModel.completionPercentage(habits: [habit], daysBack: 30, calendar: calendar)
        #expect(pct == 100)
    }

    @Test func completionPercentage_specificDaysHabit_onlyCountsScheduledDays() throws {
        let context = try makeContext()
        let calendar = Calendar.current
        let today = Weekday(date: .now)
        let habit = Habit(title: "MWF Habit", frequency: .specificDays([today]))
        habit.createdAt = calendar.date(byAdding: .day, value: -6, to: .now)!
        context.insert(habit)
        context.insert(HabitEntry(date: .now, habit: habit))

        let pct = AnalyticsViewModel.completionPercentage(habits: [habit], daysBack: 7, calendar: calendar)
        #expect(pct == 100)
    }
}
