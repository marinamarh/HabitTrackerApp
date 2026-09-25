//
//  HabitScreen.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 13.07.2026.
//

import SwiftUI
import SwiftData

struct HabitScreen: View {
    @State private var selectedDate = Date()
    @State private var isPresented: Bool = false
    @State private var visibleMonth = Date()
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's rhythm")
                            .font(.system(size: 34, weight: .regular, design: .serif))
                            .foregroundStyle(.primary)
                    }
                    
                    Spacer()
                    
                    Button {
                        isPresented = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(Color(uiColor: .systemBackground))
                            .frame(width: 48, height: 48)
                            .background(Color.primary)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                VStack(alignment: .leading ,spacing: 24) {
                    HStack {
                        Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        if !calendar.isDateInToday(selectedDate) {
                            Button("Today") {
                                withAnimation(.snappy) {
                                    selectedDate = .now
                                }
                            }
                            .tint(Color.sageGreen)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    CalendarView(updatesDateOnScroll: true, date: $selectedDate) { day in
                        CalendarDayCell(
                            day: day,
                            isSelected: calendar.isDate(selectedDate, inSameDayAs: day.date),
                            isToday: calendar.isDateInToday(day.date),
                            onTap: {
                                withAnimation(.snappy) {
                                    selectedDate = day.date
                                }
                            }
                        )
                    }
                    .padding(.horizontal, 16)
                    
                    HabitList(selectedDate: selectedDate)
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            AddHabitView()
        }
    }
}

#Preview {
    HabitScreen()
        .modelContainer(SampleData.previewContainer)
        .environment(NotificationService())
}
