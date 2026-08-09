//
//  HabitsProvider.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 07.08.2026.
//


import WidgetKit
import SwiftData

struct HabitsEntry: TimelineEntry {
    let date: Date
    let habits: [HabitWidgetItem]
}

nonisolated struct HabitsProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> HabitsEntry {
        HabitsEntry(date: .now, habits: HabitWidgetItem.placeholders)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HabitsEntry) -> Void) {
        if context.isPreview {
            completion(HabitsEntry(date: .now, habits: HabitWidgetItem.placeholders))
        } else {
            completion(HabitsEntry(date: .now, habits: fetchTodaysHabits()))
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HabitsEntry>) -> Void) {
        let entry = HabitsEntry(date: .now, habits: fetchTodaysHabits())
        
        let nextMidnight = Calendar.current.nextDate(
            after: .now,
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTime
        ) ?? .now.addingTimeInterval(3600)
        
        completion(Timeline(entries: [entry], policy: .after(nextMidnight)))
    }
    
    private func fetchTodaysHabits() -> [HabitWidgetItem] {
        do {
            let container = try SharedModelContainer.make()
            let context = ModelContext(container)
            let habits = try context.fetch(FetchDescriptor<Habit>())
            let today = Date.now
            
            return habits
                .filter { $0.isScheduled(on: today) }
                .sorted { $0.title < $1.title }
                .map {
                    HabitWidgetItem(
                        id: $0.id, title: $0.title, symbol: $0.symbol,
                        color: $0.color, isCompleted: $0.isCompleted(on: today)
                    )
                }
        } catch {
            print("Widget failed to fetch habits: \(error)")
            return []
        }
    }
}
