//
//  HabitFormView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 26.08.2026.
//

import SwiftUI

struct HabitFormView: View {
    
    let navigationTitle: String
    
    @Binding var title: String
    @Binding var symbol: HabitSymbol
    @Binding var color: HabitColor
    @Binding var isEveryday: Bool
    @Binding var selectedDays: Set<Weekday>
    @Binding var isReminderEnabled: Bool
    @Binding var reminderTime: Date
    
    let onSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @Environment(NotificationService.self) private var notificationService
    @State private var showPermissionAlert = false
    
    private var isSaveDisabled: Bool {
        title.isEmpty || (!isEveryday && selectedDays.isEmpty)
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
                            .background(color.color)
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
                                    withAnimation { color = habitColor }
                                } label: {
                                    Circle()
                                        .fill(habitColor.color.gradient)
                                        .frame(width: 44, height: 44)
                                        .overlay {
                                            if color == habitColor {
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
                                        .background(symbol == habitSymbol ? color.color : Color(UIColor.tertiarySystemFill))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding([.vertical, .horizontal], 8)
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: onSave)
                        .disabled(isSaveDisabled)
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
    
    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

#Preview {
    HabitFormView(
        navigationTitle: "New Habit",
        title: .constant(""),
        symbol: .constant(.book),
        color: .constant(.green),
        isEveryday: .constant(true),
        selectedDays: .constant([]),
        isReminderEnabled: .constant(false),
        reminderTime: .constant(.now),
        onSave: {}
    )
    .environment(NotificationService())
}
