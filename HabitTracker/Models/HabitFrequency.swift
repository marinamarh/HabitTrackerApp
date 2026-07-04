//
//  HabitFrequency.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 04.07.2026.
//

import Foundation

enum HabitFrequency: Codable, Hashable {
    case daily
    case timePerWeek(Int)
    
    var label: String {
        switch self {
        case .daily:
            return "Every day"
        case .timePerWeek(let cound):
            return "\(cound) days per week"
        }
    }
}
