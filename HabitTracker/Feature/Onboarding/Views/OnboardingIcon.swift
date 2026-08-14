//
//  OnboardingIcon.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 10.08.2026.
//

import SwiftUI

struct OnboardingIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.sageGreen.opacity(0.25), lineWidth: 3)
            
            Circle()
                .stroke(Color.sageGreen.opacity(0.5), lineWidth: 2)
                .padding(14)
            
            Circle()
                .fill(Color.sageGreen)
                .frame(width: 16, height: 16)
        }
        .frame(width: 72, height: 72)
    }
}

#Preview {
    OnboardingIcon()
}
