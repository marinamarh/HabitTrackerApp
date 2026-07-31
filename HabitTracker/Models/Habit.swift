//
//  Habit.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 04.07.2026.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Habit {
    @Attribute(.unique) var id: UUID

    var title: String
    var symbol: HabitSymbol
    var color: HabitColor

    private var frequencyIsDaily: Bool
    private var specificWeekdaysRaw: [String]
    
    var lastCompletedDate: Date?
    var createdAt: Date = Date.now

    @Relationship(deleteRule: .cascade, inverse: \HabitEntry.habit)
    var entries: [HabitEntry] = []

    var frequency: HabitFrequency {
        get {
            frequencyIsDaily ? .daily : .specificDays(specificWeekdaysRaw.compactMap(Weekday.init(rawValue:)))
        }
        set {
            switch newValue {
            case .daily:
                frequencyIsDaily = true
                specificWeekdaysRaw = []
            case .specificDays(let days):
                frequencyIsDaily = false
                specificWeekdaysRaw = days.map(\.rawValue)
            }
        }
    }

    init(title: String, symbol: HabitSymbol = .book, color: HabitColor = .green, frequency: HabitFrequency = .daily) {
        self.id = UUID()
        self.title = title
        self.symbol = symbol
        self.color = color
        self.lastCompletedDate = nil
        self.createdAt = .now

        switch frequency {
        case .daily:
            self.frequencyIsDaily = true
            self.specificWeekdaysRaw = []
        case .specificDays(let days):
            self.frequencyIsDaily = false
            self.specificWeekdaysRaw = days.map(\.rawValue)
        }
    }
}

extension Habit {
    var isCompletedToday: Bool {
        isCompleted(on: .now)
    }
    
    func isScheduled(on date: Date) -> Bool {
        frequency.includes(Weekday(date: date))
    }
    
    func isCompleted(on date: Date, calendar: Calendar = .current) -> Bool {
        let targetDate = calendar.startOfDay(for: date)
        return entries.contains { calendar.isDate($0.date, inSameDayAs: targetDate) }
    }
}

extension Habit {
    var uiColor: Color {
        color.color
    }
}
