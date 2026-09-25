//
//  CalendarView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 23.09.2026.
//

import SwiftUI

struct CalendarView<Content: View>: View {
    var updatesDateOnScroll: Bool
    @Binding var date: Date
    var content: (Day) -> Content

    init(
        updatesDateOnScroll: Bool = true,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Day) -> Content
    ) {
        self.updatesDateOnScroll = updatesDateOnScroll
        self._date = date
        self.content = content
        self.weeks = (-1...1).map { Week.load(from: date.wrappedValue, value: $0) }
    }

    @State private var weeks: [Week]
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var containerSize: CGSize = .zero
    @State private var isLocked: Bool = false
    @State private var lockedID: String?
    @State private var weekIndex: Int = 1
    private let calendar = Calendar.current

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(weeks) { week in
                    weekRow(week)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollPosition($scrollPosition)
        .onGeometryChange(for: CGSize.self) {
            $0.size
        } action: { newValue in
            containerSize = newValue
        }
        .onAppear {
            if weeks.indices.contains(1) {
                scrollPosition.scrollTo(id: weeks[1].id)
            }
        }
        .onScrollGeometryChange(for: CGFloat.self) {
            $0.contentOffset.x + $0.contentInsets.leading
        } action: { _, newValue in
            handleScrollOffsetChange(newValue)
        }
        .onChange(of: weekIndex) { _, newValue in
            updateSelectedDate(forWeekIndex: newValue)
        }
        .onChange(of: date) { _, newDate in
            recenterIfNeeded(around: newDate)
        }
    }

    @ViewBuilder
    private func weekRow(_ week: Week) -> some View {
        HStack(spacing: 0) {
            ForEach(week.days) { day in
                content(day)
                    .frame(maxWidth: .infinity)
            }
        }
        .containerRelativeFrame(.horizontal)
        .visualEffect { [isLocked, lockedID] content, proxy in
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX

            return content
                .opacity(isLocked ? (lockedID == week.id ? 1 : 0) : 1)
                .offset(x: isLocked ? -minX : 0)
        }
    }

    private func handleScrollOffsetChange(_ offset: CGFloat) {
        guard containerSize.width != .zero else { return }
        weekIndex = Int((offset / containerSize.width).rounded())

        let shouldPrependWeeks = offset < 0
        let shouldAppendWeeks = offset > containerSize.width * 2

        guard (shouldPrependWeeks || shouldAppendWeeks) && !isLocked else {
            snapBackIfNeeded(shouldPrependWeeks: shouldPrependWeeks)
            return
        }

        insertAdjacentWeeks(prepending: shouldPrependWeeks)
    }

    private func insertAdjacentWeeks(prepending: Bool) {
        guard let firstWeekDate = weeks.first?.days.first?.date,
              let lastWeekDate = weeks.last?.days.first?.date else { return }

        lockedID = prepending ? weeks.first?.id : weeks.last?.id
        isLocked = true

        if prepending {
            let previousTwoWeeks: [Week] = [
                .load(from: firstWeekDate, value: -2),
                .load(from: firstWeekDate, value: -1)
            ]
            weeks.insert(contentsOf: previousTwoWeeks, at: 0)
            weeks.removeLast(2)
        } else {
            let nextTwoWeeks: [Week] = [
                .load(from: lastWeekDate, value: 1),
                .load(from: lastWeekDate, value: 2)
            ]
            weeks.append(contentsOf: nextTwoWeeks)
            weeks.removeFirst(2)
        }
    }

    private func snapBackIfNeeded(shouldPrependWeeks: Bool) {
        guard isLocked else { return }

        var transaction = Transaction()
        transaction.scrollPositionUpdatePreservesVelocity = true
        withTransaction(transaction) {
            if shouldPrependWeeks {
                scrollPosition.scrollTo(x: containerSize.width * 2)
            } else {
                scrollPosition.scrollTo(x: -containerSize.width * 2)
            }
        }

        DispatchQueue.main.async {
            isLocked = false
            lockedID = nil
        }
    }

    private func updateSelectedDate(forWeekIndex newIndex: Int) {
        guard updatesDateOnScroll, weeks.indices.contains(newIndex) else { return }
        let symbolIndex = calendar.component(.weekday, from: date) - 1
        date = weeks[newIndex].days[symbolIndex].date
    }
    
    private func recenterIfNeeded(around targetDate: Date) {
        let isAlreadyLoaded = weeks.contains { week in
            week.days.contains { calendar.isDate($0.date, inSameDayAs: targetDate) }
        }
        guard !isAlreadyLoaded else { return }
        
        weeks = (-1...1).map { Week.load(from: targetDate, value: $0) }
        weekIndex = 1
        
        withAnimation(.snappy) {
            scrollPosition.scrollTo(id: weeks[1].id)
        }
    }
}
