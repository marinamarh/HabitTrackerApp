//
//  SharedModelContainer.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 07.08.2026.
//

import SwiftData
import Foundation

enum AppGroup {
    static let identifier = "group.mm.HabitTracker"
    static let widgetKind = "HabitTrackerWidget"
}

enum SharedModelContainer {
    static func make() throws -> ModelContainer {
        let schema = Schema([Habit.self, HabitEntry.self])
        
        guard let groupURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: AppGroup.identifier) else {
            fatalError("App Group container not found - check the App Groups capability on both targets")
        }
        
        let storeURL = groupURL.appendingPathComponent("HabitTracker.sqlite")
        let configuration = ModelConfiguration(schema: schema, url: storeURL)
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
