//
//  HabitEntry.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 04.07.2026.
//

import Foundation
import SwiftData

@Model
class HabitEntry {
    @Attribute(.unique) var id: UUID
    
    var date: Date
    var completionCount: Int
    var habit: Habit?
    
    init(date: Date = .now, completionCount: Int = 1, habit: Habit? = nil) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.completionCount = completionCount
        self.habit = habit
    }
}
