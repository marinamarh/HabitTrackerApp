//
//  HabitWidgetItem.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 07.08.2026.
//


import SwiftUI

struct HabitWidgetItem: Identifiable {
    let id: UUID
    let title: String
    let symbol: HabitSymbol
    let color: HabitColor
    let isCompleted: Bool
}

extension HabitWidgetItem {
    static let placeholders: [HabitWidgetItem] = [
        HabitWidgetItem(id: UUID(), title: "Read", symbol: .book, color: .blue, isCompleted: true),
        HabitWidgetItem(id: UUID(), title: "Meditate", symbol: .brain, color: .purple, isCompleted: false),
        HabitWidgetItem(id: UUID(), title: "Workout", symbol: .dumbbell, color: .orange, isCompleted: false)
    ]
}