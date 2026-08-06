//
//  ContentView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 04.07.2026.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            Tab("Habits", systemImage: "checklist") {
                HabitScreen()
            }
            
            Tab("Analytics", systemImage: "chart.bar.xaxis") {
                AnalyticsScreen()
            }
            
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingView()
            }
        }
        .tint(.primary)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Habit.self, HabitEntry.self], inMemory: true)
}
