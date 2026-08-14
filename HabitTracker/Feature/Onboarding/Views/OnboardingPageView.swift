//
//  OnboardingPageView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 10.08.2026.
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 24) {
            OnboardingIcon()
            
            VStack(spacing: 12) {
                Text(page.eyebrow)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .tracking(2)
                    .foregroundStyle(.secondary)
                
                Text(page.title)
                    .font(.system(.largeTitle, design: .serif))
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    OnboardingPageView(page: OnboardingPage.all[0])
}
