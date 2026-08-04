//
//  HabitEntry.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 20.07.2026.
//

import Foundation
import SwiftData

@Model
class HabitEntry {
    @Attribute(.unique) var id: UUID
    
    var date: Date
    var habit: Habit?
    
    init(date: Date = .now, habit: Habit? = nil) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.habit = habit
    }
}
