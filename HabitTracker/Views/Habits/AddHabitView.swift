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
                
                Section {
                    TextField("Habit Name", text: $title)
                        .autocorrectionDisabled(true)
                }
                
                Section("Frequency") {
                    Toggle("Everyday", isOn: $isEveryday.animation())
                        .tint(.green.mix(with: .gray, by: 0.65))
                    
                    if !isEveryday {
                        WeekdayPicker(selectedDays: $selectedDays)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
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
        }
    }
    
    private func saveHabit() {
        let frequency: HabitFrequency = isEveryday ? .daily : .specificDays(Array(selectedDays))
        let habit = Habit(title: title, symbol: symbol, color: UIcolor, frequency: frequency)
        modelContext.insert(habit)
        dismiss()
    }
}

#Preview {
    AddHabitView()
        .modelContainer(SampleData.previewContainer)
}
