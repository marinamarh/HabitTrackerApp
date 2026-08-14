//
//  OnboardingProgressBar.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 10.08.2026.
//

import SwiftUI

struct OnboardingProgressBar: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index <= currentPage ? Color.sageGreen : Color(.systemGray5))
                    .frame(height: 4)
            }
        }
    }
}

#Preview {
    OnboardingProgressBar(currentPage: 0, totalPages: 3)
        .padding()
}
