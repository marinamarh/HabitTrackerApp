//
//  HabitRow.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 17.07.2026.
//

import SwiftUI
import SwiftData

struct HabitRow: View {
    let habit: Habit
    let selectedDate: Date
    let onToggle: () -> Void
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: habit.symbol.systemName)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(habit.uiColor)
                .clipShape(Circle())
            
            Text(habit.title)
                .font(.body)
            
            Spacer()
            
            Button {
                withAnimation(.snappy) {
                    onToggle()
                }
            } label: {
                Image(systemName: habit.isCompleted(on: selectedDate) ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(habit.isCompleted(on: selectedDate) ? habit.uiColor : Color.secondary)
            }
            .buttonStyle(.plain)
            .disabled(!isToday)
        }
        .padding(.vertical, 4)
        .opacity(isToday ? 1 : 0.5)
    }
}

#Preview {
    HabitRow(
        habit: Habit(title: "Drink Water", symbol: .drop, color: .blue),
        selectedDate: .now,
        onToggle: {}
    )
    .padding()
}
