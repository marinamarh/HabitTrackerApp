//
//  MonthDays.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 05.10.2026.
//

import Foundation

enum MonthDays {
    static func days(
        firstLaunch: Date,
        today: Date = .now,
        calendar: Calendar = .current
    ) -> [Date] {
        guard let month = calendar.dateInterval(of: .month, for: today) else { return [] }
        
        var current = max(calendar.startOfDay(for: firstLaunch), month.start)
        var result: [Date] = []
        
        while current < month.end {
            result.append(current)
            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }
        return result
    }
}
