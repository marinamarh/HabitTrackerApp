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
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(NotificationService.self) private var notificationService
    
    @State private var title: String
    @State private var symbol: HabitSymbol
    @State private var UIcolor: HabitColor
    @State private var isEveryday: Bool
    @State private var selectedDays: Set<Weekday>
    
    @State private var isReminderEnabled: Bool
    @State private var reminderTime: Date
    @State private var showPermissionAlert = false
    
    init(habit: Habit) {
        self.habit = habit
        
        _title = State(initialValue: habit.title)
        _symbol = State(initialValue: habit.symbol)
        _UIcolor = State(initialValue: habit.color)
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
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: symbol.systemName)
                            .font(.system(size: 48, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 100)
                            .background(UIcolor.color)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 8)
                }
                
                Section("Name") {
                    TextField("Habit Name", text: $title)
                        .autocorrectionDisabled(true)
                }
                
                Section("Frequency") {
                    Toggle("Everyday", isOn: $isEveryday.animation())
                        .tint(Color.sageGreen)
                    
                    if !isEveryday {
                        WeekdayPicker(selectedDays: $selectedDays)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                
                Section("Reminder") {
                    Toggle("Remind Me", isOn: $isReminderEnabled.animation())
                        .tint(Color.sageGreen)
                    
                    if isReminderEnabled {
                        DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
                .onChange(of: isReminderEnabled) { _, isEnabled in
                    guard isEnabled else { return }
                    Task {
                        try? await notificationService.requestAuthorization()
                        if notificationService.permission != .authorized {
                            isReminderEnabled = false
                            showPermissionAlert = true
                        }
                    }
                }
                
                Section("Color") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(HabitColor.allCases, id: \.self) { habitColor in
                                Button {
                                    withAnimation { UIcolor = habitColor }
                                } label: {
                                    Circle()
                                        .fill(habitColor.color.gradient)
                                        .frame(width: 44, height: 44)
                                        .overlay {
                                            if UIcolor == habitColor {
                                                Circle()
                                                    .stroke(Color.gray.opacity(0.5), lineWidth: 3)
                                                    .padding(-4)
                                            }
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding([.vertical, .horizontal], 8)
                    }
                }
                
                Section("Icon") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(HabitSymbol.allCases, id: \.self) { habitSymbol in
                                Button {
                                    withAnimation { symbol = habitSymbol }
                                } label: {
                                    Image(systemName: habitSymbol.systemName)
                                        .font(.title2)
                                        .foregroundStyle(symbol == habitSymbol ? .white : .primary)
                                        .frame(width: 44, height: 44)
                                        .background(symbol == habitSymbol ? UIcolor.color : Color(UIColor.tertiarySystemFill))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding([.vertical, .horizontal], 8)
                    }
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveHabit() }
                        .disabled(title.isEmpty || (!isEveryday && selectedDays.isEmpty))
                }
            }
            .alert("Notifications Disabled", isPresented: $showPermissionAlert) {
                Button("Open Settings") { openSystemSettings() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Enable notifications in system Settings to get reminders for this habit.")
            }
        }
    }
    
    private func saveHabit() {
        habit.title = title
        habit.symbol = symbol
        habit.color = UIcolor
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
    
    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

#Preview {
    EditHabitView(habit: Habit(title: "Workout", symbol: .dumbbell, color: .green))
        .modelContainer(SampleData.previewContainer)
        .environment(NotificationService())
}
