//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 08.07.2026.
//

import SwiftUI
import SwiftData
import WidgetKit

struct AddHabitView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(NotificationService.self) private var notificationService
    
    @State private var title = ""
    @State private var symbol: HabitSymbol
    @State private var color: HabitColor
    @State private var isEveryday = true
    @State private var selectedDays: Set<Weekday> = []
    
    @State private var isReminderEnabled = false
    @State private var reminderTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: .now) ?? .now
    
    var onSave: (() -> Void)? = nil
    
    init(onSave: (() -> Void)? = nil) {
        let randomDefaults = Habit.createRandom()
        _symbol = State(initialValue: randomDefaults.symbol)
        _color = State(initialValue: randomDefaults.color)
        self.onSave = onSave
    }
    
    var body: some View {
        HabitFormView(
            navigationTitle: "New Habit",
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
        let frequency: HabitFrequency = isEveryday ? .daily : .specificDays(Array(selectedDays))
        let habit = Habit(
            title: title,
            symbol: symbol,
            color: color,
            frequency: frequency,
            reminderTime: isReminderEnabled ? reminderTime : nil
        )
        modelContext.insert(habit)
        try? modelContext.save()
        WidgetCenter.shared.reloadTimelines(ofKind: AppGroup.widgetKind)
        
        if isReminderEnabled {
            Task { await notificationService.scheduleReminder(for: habit) }
        }
        
        onSave?()
        dismiss()
    }
}

#Preview {
    AddHabitView()
        .modelContainer(SampleData.previewContainer)
        .environment(NotificationService())
}
