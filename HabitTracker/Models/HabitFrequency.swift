//
//  HabitFrequency.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 04.07.2026.
//

import Foundation

enum HabitFrequency: Codable, Hashable {
    case daily
    case timesPerWeek(Int)
    
    var label: String {
        switch self {
        case .daily:
            return "Every day"
        case .timesPerWeek(let count):
            return "\(count) days per week"
        }
    }
}
