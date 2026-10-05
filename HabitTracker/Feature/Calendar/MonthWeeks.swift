//
//  MonthWeeks.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 05.10.2026.
//

import Foundation

enum MonthWeeks {
    static func pages(
        firstLaunch: Date,
        today: Date = .now,
        calendar: Calendar = .current
    ) -> [WeekPage] {
        let days = MonthDays.days(firstLaunch: firstLaunch, today: today, calendar: calendar)
        let grouped = Dictionary(grouping: days) { weekStart(of: $0, calendar: calendar) }
        
        return grouped.keys.sorted().map { start in
            let visible = Set(grouped[start] ?? [])
            let slots: [Date?] = (0..<7).map { offset in
                guard let date = calendar.date(byAdding: .day, value: offset, to: start) else { return nil }
                let day = calendar.startOfDay(for: date)
                return visible.contains(day) ? day : nil
            }
            return WeekPage(id: start, slots: slots)
        }
    }
    
    static func pageID(containing date: Date, calendar: Calendar = .current) -> Date {
        weekStart(of: date, calendar: calendar)
    }
    
    private static func weekStart(of date: Date, calendar: Calendar) -> Date {
        calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? calendar.startOfDay(for: date)
    }
}
