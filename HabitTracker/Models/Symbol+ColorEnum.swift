//
//  Symbol+ColorEnum.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 12.07.2026.
//


import Foundation
import SwiftUI

enum HabitSymbol: String, Codable, CaseIterable {
    case heart = "heart.fill"
    case pills = "pills.fill"
    case cart = "cart.fill"
    case book = "book.fill"
    case paintbrush = "paintbrush.fill"
    case brain = "brain.head.profile"
    case leaf = "leaf.fill"
    case drop = "drop.fill"
    case moon = "moon.stars.fill"
    case bed = "bed.double.fill"
    case forkKnife = "fork.knife"
    case cup = "cup.and.saucer.fill"
    case sun = "sun.max.fill"
    case flame = "flame.fill"
    case dumbbell = "dumbbell.fill"
    case figureYoga = "figure.yoga"
    case clock = "clock.fill"
    case star = "star.fill"
    case flower = "camera.macro"
    case pencil = "pencil"
    case music = "music.note"
    case game = "gamecontroller.fill"
    case puzzlepiece = "puzzlepiece.fill"
    case bicycle = "bicycle"
    case figureWalk = "figure.walk"
    case dog = "dog.fill"
    
    var systemName: String {
        rawValue
    }
}

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
