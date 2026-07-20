//
//  HabitList.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 08.07.2026.
//

import SwiftUI
import SwiftData

struct HabitList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    
    @State private var habitToEdit: Habit?
    
    let selectedDate: Date
    
    private var scheduledHabits: [Habit] {
        habits.filter { $0.isScheduled(on: selectedDate) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(selectedDate.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            if scheduledHabits.isEmpty {
                ContentUnavailableView(
                    "No habits for this day",
                    systemImage: "checklist"
                )
            } else {
                List {
                    ForEach(scheduledHabits) { habit in
                        HabitRow(habit: habit, selectedDate: selectedDate)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    modelContext.delete(habit)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button() {
                                    habitToEdit = habit
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.orange)
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .sheet(item: $habitToEdit) { habit in
            EditHabitView(habit: habit)
        }
    }
}

#Preview {
    HabitList(selectedDate: Date.now)
        .modelContainer(SampleData.previewContainer)
}
