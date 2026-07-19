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
    
    @State private var habit: Habit = Habit.createRandom()
    @State private var isEveryday = true
    @State private var selectedDays: Set<Weekday> = []
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: habit.symbol.systemName)
                            .font(.system(size: 48, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 100)
                            .background(habit.uiColor)
                            .clipShape(Circle())
                            .shadow(color: habit.uiColor.opacity(0.3), radius: 8, y: 4)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 8)
                }
                
                Section {
                    TextField("Habit Name", text: $habit.title)
                        .autocorrectionDisabled(true)
                }
                
                Section("Frequency") {
                    Toggle("Everyday", isOn: $isEveryday.animation())
                    
                    if !isEveryday {
                        WeekdayPicker(selectedDays: $selectedDays)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                
                Section("Color") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                        ForEach(HabitColor.allCases, id: \.self) { habitColor in
                            Button {
                                withAnimation { habit.color = habitColor }
                            } label: {
                                Circle()
                                    .fill(habitColor.color.gradient)
                                    .frame(width: 44, height: 44)
                                    .overlay {
                                        if habit.color == habitColor {
                                            Circle()
                                                .stroke(Color.gray.opacity(0.5), lineWidth: 3)
                                                .padding(-4)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                        ForEach(HabitSymbol.allCases, id: \.self) { habitSymbol in
                            Button {
                                withAnimation { habit.symbol = habitSymbol }
                            } label: {
                                Image(systemName: habitSymbol.systemName)
                                    .font(.title2)
                                    .foregroundStyle(habit.symbol == habitSymbol ? .white : .primary)
                                    .frame(width: 44, height: 44)
                                    .background(habit.symbol == habitSymbol ? Color.gray.opacity(0.8) : Color(UIColor.tertiarySystemFill))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
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
                        .disabled(habit.title.isEmpty || (!isEveryday && selectedDays.isEmpty))
                }
            }
        }
    }
    
    private func saveHabit() {
        habit.frequency = isEveryday ? .daily : .specificDays(Array(selectedDays))
        modelContext.insert(habit)
        dismiss()
    }
}

#Preview {
    AddHabitView()
        .modelContainer(SampleData.previewContainer)
}
