//
//  CalendarView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 23.09.2026.
//

import SwiftUI

struct CalendarView: View {
    let pages: [WeekPage]
    @Binding var selectedDate: Date
    @Binding var pageID: Date?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(pages) { page in
                    WeekRow(slots: page.slots, selectedDate: $selectedDate)
                        .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $pageID)
        .scrollIndicators(.hidden)
        .fixedSize(horizontal: false, vertical: true)
    }
}

private struct WeekRow: View {
    let slots: [Date?]
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(slots.indices, id: \.self) { index in
                if let day = slots[index] {
                    Button {
                        selectedDate = day
                    } label: {
                        DayCell(
                            date: day,
                            isSelected: Calendar.current.isDate(day, inSameDayAs: selectedDate)
                        )
                    }
                    .buttonStyle(.plain)
                } else {
                    Color.clear
                }
            }
        }
    }
}

private struct DayCell: View {
    let date: Date
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(date, format: .dateTime.weekday(.abbreviated))
                .font(.caption)
            Text(date, format: .dateTime.day())
                .font(.title3.bold())
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .foregroundStyle(isSelected ? Color.white : Color.primary)
        .background(
            isSelected ? Color.accentColor : Color(uiColor: .secondarySystemFill),
            in: .rect(cornerRadius: 12)
        )
    }
}

#Preview {
    @Previewable @State var selectedDate = Calendar.current.startOfDay(for: .now)
    @Previewable @State var pageID: Date? = MonthWeeks.pageID(containing: .now)

    CalendarView(
        pages: MonthWeeks.pages(firstLaunch: .now),
        selectedDate: $selectedDate,
        pageID: $pageID
    )
}
