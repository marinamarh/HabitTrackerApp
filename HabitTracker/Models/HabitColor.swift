//
//  HabitColor.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 23.09.2026.
//

import Foundation
import SwiftUI

enum HabitColor: String, Codable, CaseIterable {
    case green
    case cyan
    case blue
    case yellow
    case indigo
    case purple
    case red
    case orange
    
    var color: Color {
        switch self {
        case .green:
            Color.green.mix(with: .gray, by: 0.5)
        case .cyan:
            Color.cyan.mix(with: .gray, by: 0.5)
        case .blue:
            Color.blue.mix(with: .gray, by: 0.5)
        case .yellow:
            Color.yellow.mix(with: .gray, by: 0.5)
        case .indigo:
            Color.indigo.mix(with: .gray, by: 0.5)
        case .purple:
            Color.purple.mix(with: .gray, by: 0.5)
        case .red:
            Color.red.mix(with: .gray, by: 0.5)
        case .orange:
            Color.orange.mix(with: .gray, by: 0.5)
        }
    }
}
