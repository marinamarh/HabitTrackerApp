//
//  SampleData.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 08.07.2026.
//

import Foundation
import SwiftData

struct SampleData {
    
    static func seedIfNeeded(in context: ModelContext) throws {
        let habitFetchDescriptor = FetchDescriptor<Habit>(fetchLimit: 1)
        
        if try context.fetchCount(habitFetchDescriptor) == 0 {
            for habit in Self.allHabits {
                context.insert(habit)
            }
            
            Self.seedEntries(for: Self.allHabits, in: context)
            
            try context.save()
        }
    }
    
    private static func seedEntries(for habits: [Habit], in context: ModelContext) {
        let calendar = Calendar.current
        let dailyHabits = habits.filter { $0.frequency == .daily }

        for dayOffset in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: -dayOffset, to: .now) else { continue }

            if dayOffset < 3 {
                for habit in dailyHabits {
                    context.insert(HabitEntry(date: day, habit: habit))
                }
            } else {
                for (index, habit) in dailyHabits.enumerated() {
                    if (dayOffset + index) % 2 == 0 {
                        context.insert(HabitEntry(date: day, habit: habit))
                    }
                }
            }
        }

        if let water = habits.first(where: { $0.title == "Drink Water" }) {
            for dayOffset in 0..<7 {
                guard let day = calendar.date(byAdding: .day, value: -dayOffset, to: .now) else { continue }
                if water.isScheduled(on: day) {
                    context.insert(HabitEntry(date: day, habit: water))
                }
            }
        }
    }
    
    private static let allHabits: [Habit] = [
        Habit(title: "Workout", symbol: .dumbbell, color: .green, frequency: .daily),
        Habit(title: "Read", symbol: .book, color: .blue, frequency: .daily),
        Habit(title: "Drink Water", symbol: .drop, color: .cyan, frequency: .specificDays([.fri, .sat]))
    ]
    
    static let previewContainer: ModelContainer = {
        do {
            let container = try ModelContainer(
                for: Habit.self, HabitEntry.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            try SampleData.seedIfNeeded(in: container.mainContext)
            return container
        } catch {
            fatalError("Could not create model container for preview: \(error)")
        }
    }()
}

extension FetchDescriptor {
    init(predicate: Predicate<T>? = nil, sortBy: [SortDescriptor<T>] = [], fetchLimit: Int) {
        self.init(predicate: predicate, sortBy: sortBy)
        self.fetchLimit = fetchLimit
    }
}

extension Habit {
    static func createRandom() -> Habit {
        let randomSymbol = HabitSymbol.allCases.randomElement() ?? .heart
        let randomColor = HabitColor.allCases.randomElement() ?? .red
        return Habit(title: "", symbol: randomSymbol, color: randomColor)
    }
}
