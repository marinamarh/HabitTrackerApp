//
//  HabitFrequency.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 12.07.2026.
//

import Foundation

enum HabitFrequency: Codable, Hashable, Equatable {
    case daily
    case specificDays([Weekday])
    
    func includes(_ weekday: Weekday) -> Bool {
        switch self {
        case .daily:
            true
        case .specificDays(let days):
            days.contains(weekday)
        }
    }
}
