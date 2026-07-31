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
        HStack(spacing: 16) {
            Image(systemName: habit.symbol.systemName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(habit.uiColor)
                .frame(width: 52, height: 52)
                .background(habit.uiColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .foregroundStyle(.primary)
            }
            
            Spacer()
            
            Button {
                withAnimation(.snappy) {
                    onToggle()
                }
            } label: {
                Image(systemName: habit.isCompleted(on: selectedDate) ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(
                        habit.isCompleted(on: selectedDate)
                        ? Color.sageGreen
                        : Color.secondary.opacity(0.3)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .opacity(isToday ? 1 : 0.5)
    }
}

#Preview {
    VStack(spacing: 12) {
        HabitRow(
            habit: Habit(title: "Morning meditation", symbol: .drop, color: .green),
            selectedDate: .now,
            onToggle: {}
        )
        
        HabitRow(
            habit: Habit(title: "Read a book", symbol: .book, color: .blue),
            selectedDate: Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
            onToggle: {}
        )
    }
    .padding()
}
