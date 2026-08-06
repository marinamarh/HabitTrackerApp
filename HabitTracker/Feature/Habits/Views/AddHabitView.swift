//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 08.07.2026.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var symbol: HabitSymbol
    @State private var UIcolor: HabitColor
    @State private var isEveryday = true
    @State private var selectedDays: Set<Weekday> = []
    
    @State private var isReminderEnabled = false
    @State private var reminderTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: .now) ?? .now
    @State private var showPermissionAlert = false
    
    init() {
        let randomDefaults = Habit.createRandom()
        _symbol = State(initialValue: randomDefaults.symbol)
        _UIcolor = State(initialValue: randomDefaults.color)
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
                        let granted = await NotificationManager.requestAuthorization()
                        if !granted {
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
            .navigationTitle("New Habit")
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
        let frequency: HabitFrequency = isEveryday ? .daily : .specificDays(Array(selectedDays))
        let habit = Habit(
            title: title,
            symbol: symbol,
            color: UIcolor,
            frequency: frequency,
            reminderTime: isReminderEnabled ? reminderTime : nil
        )
        modelContext.insert(habit)
        
        if isReminderEnabled {
            NotificationManager.scheduleReminder(for: habit)
        }
        
        dismiss()
    }
    
    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

#Preview {
    AddHabitView()
        .modelContainer(SampleData.previewContainer)
}
