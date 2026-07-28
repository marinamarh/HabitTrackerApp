//
//  WeeklyCompletionChart.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 27.07.2026.
//

import SwiftUI
import Charts

struct WeeklyCompletionChart: View {
    let weeklyData: [DailyCompletion]

    @State private var rawSelectedDate: Date?

    private var selectedDay: DailyCompletion? {
        guard let rawSelectedDate else { return nil }
        return weeklyData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }

    private var maxCompletedCount: Int {
        weeklyData.map(\.completedCount).max() ?? 0
    }

    var body: some View {
        Chart {
            if let selectedDay {
                RuleMark(x: .value("Selected Day", selectedDay.date, unit: .day))
                    .foregroundStyle(.secondary.opacity(0.3))
                    .annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                        VStack {
                            Text(selectedDay.date, format: .dateTime.weekday(.abbreviated).day())
                                .bold()

                            Text("\(selectedDay.completedCount)")
                                .font(.title3.bold())
                        }
                        .foregroundStyle(.white)
                        .padding(12)
                        .frame(width: 100)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.mix(with: .gray, by: 0.65).gradient))
                    }
            }
            
            ForEach(weeklyData) { entry in
                BarMark(
                    x: .value("Day", entry.date, unit: .day),
                    y: .value("Completed", entry.completedCount)
                )
                .foregroundStyle(Color.green.mix(with: .gray, by: 0.65))
                .cornerRadius(4)
                .opacity(rawSelectedDate == nil || entry.date == selectedDay?.date ? 1 : 0.3)
            }
        }
        .frame(height: 160)
        .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisValueLabel(format: .dateTime.weekday(.narrow))
            }
        }
        .chartYAxis(.hidden)
        .chartYScale(domain: 0...(maxCompletedCount + 3))
    }
}

#Preview {
    WeeklyCompletionChart(weeklyData: [
        DailyCompletion(date: .now.addingTimeInterval(-6 * 86400), completedCount: 1),
        DailyCompletion(date: .now.addingTimeInterval(-5 * 86400), completedCount: 2),
        DailyCompletion(date: .now.addingTimeInterval(-4 * 86400), completedCount: 3),
        DailyCompletion(date: .now.addingTimeInterval(-3 * 86400), completedCount: 2),
        DailyCompletion(date: .now.addingTimeInterval(-2 * 86400), completedCount: 3),
        DailyCompletion(date: .now.addingTimeInterval(-1 * 86400), completedCount: 3),
        DailyCompletion(date: .now, completedCount: 1)
    ])
    .padding()
}
