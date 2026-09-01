//
//  AnalyticsScreen.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 26.07.2026.
//

import SwiftUI
import SwiftData

struct AnalyticsScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                AnalyticsDashboardView()
                    .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    AnalyticsScreen()
        .modelContainer(SampleData.previewContainer)
}
