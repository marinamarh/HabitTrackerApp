//
//  WeekPage.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 05.10.2026.
//


import Foundation

struct WeekPage: Identifiable, Equatable {
    let id: Date
    let slots: [Date?]
}