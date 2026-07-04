//
//  ContentView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 04.07.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]

    var body: some View {
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
