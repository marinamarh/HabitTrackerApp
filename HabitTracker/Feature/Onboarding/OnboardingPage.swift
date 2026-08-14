//
//  OnboardingPage.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 10.08.2026.
//

import Foundation

struct OnboardingPage: Identifiable {
    let id = UUID()
    let eyebrow: String
    let title: String
    let description: String
}

extension OnboardingPage {
    static let all: [OnboardingPage] = [
        OnboardingPage(
            eyebrow: "RHYTHM",
            title: "Small steps,\nevery day.",
            description: "Build habits that stick with a calm, gentle daily rhythm — no streaks to stress over, just quiet progress."
        ),
        OnboardingPage(
            eyebrow: "PROGRESS",
            title: "See your\nconsistency.",
            description: "Track your streaks and completion patterns with simple, clear charts — no noise, just the shape of your habits."
        ),
        OnboardingPage(
            eyebrow: "REMINDERS",
            title: "A gentle\nnudge.",
            description: "Set a reminder for each habit, right when you need it. Notifications are optional and fully in your control."
        )
    ]
}
