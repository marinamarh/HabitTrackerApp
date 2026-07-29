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
        VStack(alignment: .leading, spacing: 20) {
            
            if !scheduledHabits.isEmpty {
                let completedCount = scheduledHabits.filter { $0.isCompleted(on: selectedDate) }.count
                let totalCount = scheduledHabits.count
                
                DailyProgressBar(completedCount: completedCount, totalCount: totalCount)
                    .padding(.horizontal, 24)
            }
            
            if scheduledHabits.isEmpty {
                ContentUnavailableView(
                    "No habits for this day",
                    systemImage: "checklist"
                )
            } else {
                List {
                    ForEach(scheduledHabits) { habit in
                        HabitRow(habit: habit, selectedDate: selectedDate) {
                            toggleCompletion(for: habit)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 24, bottom: 6, trailing: 24))
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                modelContext.delete(habit)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
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
    
    private func toggleCompletion(for habit: Habit) {
        if habit.isCompleted(on: selectedDate) {
            uncomplete(habit)
        } else {
            complete(habit)
        }
    }
    
    private func complete(_ habit: Habit) {
        habit.lastCompletedDate = .now
        let entry = HabitEntry(date: selectedDate, habit: habit)
        modelContext.insert(entry)
    }
    
    private func uncomplete(_ habit: Habit) {
        let targetDate = Calendar.current.startOfDay(for: selectedDate)
        if let entry = habit.entries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: targetDate) }) {
            modelContext.delete(entry)
        }
    }
}

#Preview {
    HabitList(selectedDate: Date.now)
        .modelContainer(SampleData.previewContainer)
}
