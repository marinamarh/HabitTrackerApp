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
            
            try context.save()
        }
    }
    
    private static let allHabits: [Habit] = [
        Habit(title: "Workout", symbol: .dumbbell, color: .green, frequency: .daily),
        Habit(title: "Read", symbol: .book, color: .blue, frequency: .daily),
        Habit(title: "Drink Water", symbol: .drop, color: .mint, frequency: .specificDays([.fri, .sat]))
    ]
    
    static let previewContainer: ModelContainer = {
        do {
            let container = try ModelContainer(
                for: Habit.self,
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
