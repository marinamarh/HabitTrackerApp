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
    @State private var viewModel = AnalyticsViewModel()
    
    var body: some View {
        if habits.isEmpty {
            ContentUnavailableView(
                "No Data Yet",
                systemImage: "chart.bar.xaxis",
                description: Text("Create your first habit to start tracking your progress and consistency.")
            )
            .containerRelativeFrame(.vertical)
        } else {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("This month")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("Your progress")
                        .font(.system(.largeTitle, design: .serif))
                }
                ConsistencyRing()
                
                HStack(spacing: 12) {
                    StreakCard(value: viewModel.currentStreak, label: "Current best streak")
                    StreakCard(value: viewModel.longestStreak, label: "Longest ever, in days")
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Completion")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("Week \(weekPercentage)% · Month \(monthPercentage)%")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                    WeeklyCompletionChart(weeklyData: viewModel.weeklyData)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                }
            }
            .onAppear {
                viewModel.loadWeeklyData(from: entries)
                viewModel.loadStreaks(from: habits)
            }
        }
    }
    
    private var weekPercentage: Int {
        0
    }
    
    private var monthPercentage: Int {
        0
    }
}

#Preview {
    AnalyticsView()
        .modelContainer(SampleData.previewContainer)
}
