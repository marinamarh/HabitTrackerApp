//
//  EditHabitView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 19.07.2026.
//

import SwiftUI
import SwiftData
import WidgetKit

struct EditHabitView: View {
    
    let habit: Habit
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(NotificationService.self) private var notificationService
    
    @State private var title: String
    @State private var symbol: HabitSymbol
    @State private var color: HabitColor
    @State private var isEveryday: Bool
    @State private var selectedDays: Set<Weekday>
    
    @State private var isReminderEnabled: Bool
    @State private var reminderTime: Date
    
    init(habit: Habit) {
        self.habit = habit
        
        _title = State(initialValue: habit.title)
        _symbol = State(initialValue: habit.symbol)
        _color = State(initialValue: habit.color)
        _isReminderEnabled = State(initialValue: habit.reminderTime != nil)
        _reminderTime = State(initialValue: habit.reminderTime ?? Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: .now) ?? .now)
        
        switch habit.frequency {
        case .daily:
            _isEveryday = State(initialValue: true)
            _selectedDays = State(initialValue: [])
        case .specificDays(let days):
            _isEveryday = State(initialValue: false)
            _selectedDays = State(initialValue: Set(days))
        }
    }
    
    var body: some View {
        HabitFormView(
            navigationTitle: "Edit Habit",
            title: $title,
            symbol: $symbol,
            color: $color,
            isEveryday: $isEveryday,
            selectedDays: $selectedDays,
            isReminderEnabled: $isReminderEnabled,
            reminderTime: $reminderTime,
            onSave: saveHabit
        )
    }
    
    private func saveHabit() {
        habit.title = title
        habit.symbol = symbol
        habit.color = color
        habit.frequency = isEveryday ? .daily : .specificDays(Array(selectedDays))
        habit.reminderTime = isReminderEnabled ? reminderTime : nil
        try? modelContext.save()
        WidgetCenter.shared.reloadTimelines(ofKind: AppGroup.widgetKind)
        
        if isReminderEnabled {
            Task { await notificationService.scheduleReminder(for: habit) }
        } else {
            notificationService.cancelReminder(for: habit)
        }
        
        dismiss()
    }
}

#Preview {
    EditHabitView(habit: Habit(title: "Workout", symbol: .dumbbell, color: .green))
        .modelContainer(SampleData.previewContainer)
        .environment(NotificationService())
}
