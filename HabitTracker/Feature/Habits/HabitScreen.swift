//
//  HabitScreen.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 13.07.2026.
//

import SwiftUI
import SwiftData

struct HabitScreen: View {
    @State private var selectedDate = Calendar.current.startOfDay(for: .now)
    @State private var pageID: Date? = MonthWeeks.pageID(containing: .now)
    @State private var isAddHabitPresented = false
    
    private var pages: [WeekPage] { MonthWeeks.pages(firstLaunch: FirstLaunch.date) }
    private var today: Date { Calendar.current.startOfDay(for: .now) }
    private var todayPageID: Date { MonthWeeks.pageID(containing: today) }
    
    private var isShowingToday: Bool {
        Calendar.current.isDateInToday(selectedDate) && pageID == todayPageID
    }
    
    var body: some View {
        NavigationStack {
            List {
                calendarSection
                HabitList(selectedDate: selectedDate)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationTitle("Today's rhythm")
            .navigationBarTitleDisplayMode(.large)
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                addButton
            }
        }
        .sheet(isPresented: $isAddHabitPresented) {
            AddHabitView()
        }
    }
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            calendarHeader
            CalendarView(pages: pages, selectedDate: $selectedDate, pageID: $pageID)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var calendarHeader: some View {
        HStack {
            Text(selectedDate, format: .dateTime.month(.wide).year())
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Button("Today", action: showToday)
                .buttonStyle(.borderless)
                .disabled(isShowingToday)
        }
        .font(.subheadline)
    }
    
    private var addButton: some View {
        Button {
            isAddHabitPresented = true
        } label: {
            Label("Add habit", systemImage: "plus")
                .labelStyle(.iconOnly)
                .font(.title3.weight(.medium))
                .foregroundStyle(Color(uiColor: .systemBackground))
                .frame(maxWidth: 56, maxHeight: 56)
                .background(Color.primary)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 16)
    }
    
    private func showToday() {
        withAnimation {
            selectedDate = today
            pageID = todayPageID
        }
    }
}

#Preview {
    HabitScreen()
        .modelContainer(SampleData.previewContainer)
        .environment(NotificationService())
}
