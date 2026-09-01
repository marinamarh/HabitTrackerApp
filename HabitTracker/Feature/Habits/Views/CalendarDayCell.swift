//
//  CalendarDayCell.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 17.07.2026.
//

import SwiftUI

struct CalendarDayCell: View {
    let day: Day
    let isSelected: Bool
    let isToday: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 6) {
            Text(day.weekdaySymbol)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Text("\(day.value)")
                .font(.title3)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundStyle(
                    isSelected ? .sageGreen : (day.notFromThisMonth ? Color.gray.opacity(0.5) : Color.primary)
                )
                .frame(width: 44, height: 44)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 14, style: .continuous).fill(.selection)
                    }
                }
        }
        .contentShape(.rect)
        .onTapGesture(perform: onTap)
    }
}
