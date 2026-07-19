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

    var body: some View {
        TabView {
            Tab("Habits", systemImage: "checklist") {
                HabitScreen()
            }
            
            Tab("Charts", systemImage: "chart.bar.xaxis") {
                //
            }
            
            Tab("Settings", systemImage: "gearshape.fill") {
                //
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
