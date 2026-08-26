//
//  ContentView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 04.07.2026.
//


import SwiftUI
import SwiftData

enum AppTab: Hashable {
    case habits
    case analytics
    case settings
}

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTab: AppTab

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Habits", systemImage: "checklist", value: .habits) {
                HabitScreen()
            }
            
            Tab("Analytics", systemImage: "chart.bar.xaxis", value: .analytics) {
                AnalyticsScreen()
            }
            
            Tab("Settings", systemImage: "gearshape.fill", value: .settings) {
                SettingView()
            }
        }
        .tint(.primary)
    }
}

#Preview {
    MainTabView(selectedTab: .constant(.habits))
        .modelContainer(for: [Habit.self, HabitEntry.self], inMemory: true)
}
