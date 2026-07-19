//
//  HabitsView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 13.07.2026.
//

import SwiftUI
import SwiftData

struct HabitScreen: View {
    @State private var selectedDate = Date()
    @State private var isPresented: Bool = false
    private let calendar = Calendar.current
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                    
                    VStack {
                        CalendarView(updatesDateOnScroll: false, date: $selectedDate) { day in
                            CalendarDayCell(day: day, isSelected: calendar.isDate(selectedDate, inSameDayAs: day.date), isToday: calendar.isDateInToday(day.date),
                                            onTap: {
                                withAnimation(.snappy) {
                                    selectedDate = day.date
                                }
                            }
                            )
                        }
                    }
                    .padding()
                    
                    HabitList(selectedDate: selectedDate)
                }
                .padding(.top)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresented = true
                    } label: {
                        Label("Add habit", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                AddHabitView()
            }
        }
    }
}

#Preview {
    HabitScreen()
        .modelContainer(SampleData.previewContainer)
}
