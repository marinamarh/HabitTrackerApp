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
    case stove = "stove.fill"
    case bed = "bed.double.fill"
    case forkKnife = "fork.knife"
    case cup = "cup.and.saucer.fill"
    case sun = "sun.max.fill"
    case flame = "flame.fill"
    case dumbbell = "dumbbell.fill"
    case clock = "clock.fill"
    case washer = "washer.fill"
    case star = "star.fill"
    case car = "car.fill"
    case volleyball = "volleyball.fill"
    case calendar = "calendar"
    case pencil = "pencil"
    case music = "music.note"
    case game = "gamecontroller.fill"
    case puzzlepiece = "puzzlepiece.fill"
    case bicycle = "bicycle"
    case figureWalk = "figure.walk"
    case dog = "dog.fill"
    case figureYoga = "figure.yoga"
    
    var systemName: String {
        rawValue
    }
}

enum HabitColor: String, Codable, CaseIterable {
    case red
    case orange
    case yellow
    case cyan
    case green
    case mint
    case teal
    case blue
    case indigo
    case purple
    case pink
    case brown
    
    var color: Color {
        switch self {
        case .red:
            Color.red
        case .orange:
            Color.orange
        case .yellow:
            Color.yellow
        case .cyan:
            Color.cyan
        case .green:
            Color.green
        case .mint:
            Color.mint
        case .teal:
            Color.teal
        case .blue:
            Color.blue
        case .indigo:
            Color.indigo
        case .purple:
            Color.purple
        case .pink:
            Color.pink
        case .brown:
            Color.brown
        }
    }
}
