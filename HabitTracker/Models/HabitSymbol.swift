//
//  HabitSymbol.swift
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
