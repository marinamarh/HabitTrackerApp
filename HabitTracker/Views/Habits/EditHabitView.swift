//
//  EditHabitView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 19.07.2026.
//

import SwiftUI
import SwiftData

struct EditHabitView: View {
    
    let habit: Habit
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var symbol: HabitSymbol
    @State private var color: HabitColor
    @State private var isEveryday: Bool
    @State private var selectedDays: Set<Weekday>
    
    init(habit: Habit) {
        self.habit = habit
        
        _title = State(initialValue: habit.title)
        _symbol = State(initialValue: habit.symbol)
        _color = State(initialValue: habit.color)
        
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
                            .background(color.color)
                            .clipShape(Circle())
                            .shadow(color: color.color.opacity(0.3), radius: 8, y: 4)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 8)
                }
                
                Section {
                    TextField("Habit Name", text: $title)
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
                    .padding(.vertical, 8)
                }
                
                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                        ForEach(HabitSymbol.allCases, id: \.self) { habitSymbol in
                            Button {
                                withAnimation { symbol = habitSymbol }
                            } label: {
                                Image(systemName: habitSymbol.systemName)
                                    .font(.title2)
                                    .foregroundStyle(symbol == habitSymbol ? .white : .primary)
                                    .frame(width: 44, height: 44)
                                    .background(symbol == habitSymbol ? Color.gray.opacity(0.8) : Color(UIColor.tertiarySystemFill))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
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
        }
    }
    
    private func saveHabit() {
        habit.title = title
        habit.symbol = symbol
        habit.color = color
        habit.frequency = isEveryday ? .daily : .specificDays(Array(selectedDays))
        dismiss()
    }
}

#Preview {
    EditHabitView(habit: Habit(title: "Workout", symbol: .dumbbell, color: .green))
        .modelContainer(SampleData.previewContainer)
}
