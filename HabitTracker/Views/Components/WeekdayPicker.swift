//
//  WeekdayPicker.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 10.07.2026.
//

import SwiftUI

struct WeekdayPicker: View {
    @Binding var selectedDays: Set<Weekday>

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Weekday.allCases) { day in
                dayButton(day)
            }
        }
    }

    private func dayButton(_ day: Weekday) -> some View {
        let isSelected = selectedDays.contains(day)

        return Button {
            toggle(day)
        } label: {
            Text(day.rawValue)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? Color.accentColor : Color(uiColor: .tertiarySystemFill))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func toggle(_ day: Weekday) {
        withAnimation(.snappy) {
            if selectedDays.contains(day) {
                selectedDays.remove(day)
            } else {
                selectedDays.insert(day)
            }
        }
    }
}

#Preview {
    @Previewable @State var days: Set<Weekday> = [.mon, .wed, .fri]
    return WeekdayPicker(selectedDays: $days)
        .padding()
}
