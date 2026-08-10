//
//  AnalyticsView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 20.07.2026.
//

import SwiftUI
import SwiftData

struct AnalyticsView: View {
    @Query private var entries: [HabitEntry]
    @Query private var habits: [Habit]
    
    var body: some View {
        if habits.isEmpty {
            ContentUnavailableView(
                "No Data Yet",
                systemImage: "chart.bar.xaxis",
                description: Text("Create your first habit to start tracking your progress and consistency.")
            )
            .containerRelativeFrame(.vertical)
        } else {
            let weeklyData = AnalyticsViewModel.weeklyData(from: entries)
            let streaks = StreakCalculator.streaks(habits: habits)
            
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("This month")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("Your progress")
                        .font(.system(.largeTitle, design: .serif))
                }
                ConsistencyRing(percentage: monthPercentage)
                
                HStack(spacing: 12) {
                    StreakCard(value: streaks.current, label: "Current best streak")
                    StreakCard(value: streaks.longest, label: "Longest ever, in days")
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Completion")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("Week \(Double(weekPercentage) / 100, format: .percent.precision(.fractionLength(0))) · Month \(Double(monthPercentage) / 100, format: .percent.precision(.fractionLength(0)))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                    WeeklyCompletionChart(weeklyData: weeklyData)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                }
            }
        }
    }
    
    private var weekPercentage: Int {
        AnalyticsViewModel.completionPercentage(habits: habits, daysBack: 7)
    }
    
    private var monthPercentage: Int {
        AnalyticsViewModel.completionPercentage(habits: habits, daysBack: 30)
    }
}

#Preview {
    AnalyticsView()
        .modelContainer(SampleData.previewContainer)
}
