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

    init(title: String, symbol: HabitSymbol = .calendar, color: HabitColor = .green, frequency: HabitFrequency = .daily) {
        self.id = UUID()
        self.title = title
        self.symbol = symbol
        self.color = color
        self.lastCompletedDate = nil

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
        guard let lastCompletedDate else { return false }
        return Calendar.current.isDateInToday(lastCompletedDate)
    }

    func isScheduled(on date: Date) -> Bool {
        frequency.includes(Weekday(date: date))
    }
    
    func isCompleted(on date: Date, calendar: Calendar = .current) -> Bool {
        guard calendar.isDateInToday(date) else { return false }
        return isCompletedToday
    }
}

extension Habit {
    var uiColor: Color {
        color.color
    }
}
