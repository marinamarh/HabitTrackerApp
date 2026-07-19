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
                .font(.caption)
                .foregroundStyle(.gray)
            
            Text("\(day.value)")
                .fontWeight(isSelected || isToday ? .semibold : .regular)
                .foregroundStyle(
                    isSelected ? .white : isToday ? Color.accentColor : (
                        day.notFromThisMonth ? Color.gray : Color.primary
                    )
                )
                .frame(width: 38, height: 38)
                .background {
                    if isSelected {
                        Circle().fill(.black)
                    }
                }
        }
        .contentShape(.rect)
        .onTapGesture(perform: onTap)
    }
}
