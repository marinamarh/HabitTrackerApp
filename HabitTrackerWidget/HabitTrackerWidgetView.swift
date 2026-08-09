//
//  HabitTrackerWidgetView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 07.08.2026.
//

import SwiftUI
import WidgetKit

struct HabitTrackerWidgetView: View {
    @Environment(\.widgetFamily) private var family
    var entry: HabitsProvider.Entry
    
    private var maxVisibleHabits: Int {
        family == .systemSmall ? 4 : 8
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            if entry.habits.isEmpty {
                Text("No habits scheduled")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(entry.habits.prefix(maxVisibleHabits)) { habit in
                    HabitWidgetRow(habit: habit)
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(12)
        .containerBackground(.background, for: .widget)
        .widgetURL(URL(string: "habittracker://today"))
    }
}

private struct HabitWidgetRow: View {
    let habit: HabitWidgetItem
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.caption)
                .foregroundStyle(habit.isCompleted ? habit.color.color : .secondary)
            
            Text(habit.title)
                .font(.caption)
                .lineLimit(1)
                .strikethrough(habit.isCompleted)
                .foregroundStyle(habit.isCompleted ? .secondary : .primary)
        }
    }
}

#Preview(as: .systemSmall) {
    HabitTrackerWidget()
} timeline: {
    HabitsEntry(date: .now, habits: HabitWidgetItem.placeholders)
}
