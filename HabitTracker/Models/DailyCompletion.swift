//
//  DailyCompletion.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 20.07.2026.
//

import Foundation

struct DailyCompletion: Identifiable {
    let id = UUID()
    let date: Date
    let completedCount: Int
}
