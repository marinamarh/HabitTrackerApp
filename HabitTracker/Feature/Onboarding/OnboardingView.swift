//
//  OnboardingView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 10.08.2026.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @State private var currentPage = 0
    @State private var showAddHabit = false
    @State private var didSaveHabit = false
    private let pages = OnboardingPage.all
    
    var body: some View {
        VStack(spacing: 32) {
            OnboardingProgressBar(currentPage: currentPage, totalPages: pages.count)
                .padding(.horizontal, 24)
                .padding(.top, 16)
            
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Button {
                withAnimation {
                    if currentPage < pages.count - 1 {
                        currentPage += 1
                    } else {
                        showAddHabit = true
                    }
                }
            } label: {
                Text(currentPage < pages.count - 1 ? "Next" : "Get started")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.primary)
            .controlSize(.large)
            .buttonBorderShape(.capsule)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $showAddHabit, onDismiss: {
            guard didSaveHabit else { return }
            withAnimation(.easeInOut(duration: 0.4)) {
                hasCompletedOnboarding = true
            }
        }) {
            AddHabitView {
                didSaveHabit = true
            }
        }    }
}

#Preview {
    OnboardingView()
        .modelContainer(SampleData.previewContainer)
        .environment(NotificationService())
}
