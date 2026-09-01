//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 04.07.2026.
//

import SwiftUI
import SwiftData

@main
struct HabitTrackerApp: App {
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .system
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var notificationService = NotificationService()
    @State private var selectedTab: AppTab = .habits
    
    
    init() {
        let appearance = UINavigationBarAppearance()
        let largeTitleFont = UIFont.systemFont(ofSize: 34, weight: .regular)
        if let serifDescriptor = largeTitleFont.fontDescriptor.withDesign(.serif) {
            let serifFont = UIFont(descriptor: serifDescriptor, size: 34)
            appearance.largeTitleTextAttributes = [.font: serifFont]
        }
        
        let inlineTitleFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        if let inlineSerifDescriptor = inlineTitleFont.fontDescriptor.withDesign(.serif) {
            let inlineSerifFont = UIFont(descriptor: inlineSerifDescriptor, size: 17)
            appearance.titleTextAttributes = [.font: inlineSerifFont]
        }
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var sharedModelContainer: ModelContainer = {
        do {
            return try SharedModelContainer.make()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTabView(selectedTab: $selectedTab)
                        .transition(.opacity.combined(with: .scale(scale: 0.96)))
                } else {
                    OnboardingView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: hasCompletedOnboarding)
            .preferredColorScheme(selectedTheme.colorScheme)
            .environment(notificationService)
            .onOpenURL { url in
                handleDeepLink(url)
            }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "habittracker" else { return }
        
        switch url.host {
        case "today":
            selectedTab = .habits
        default:
            break
        }
    }
}
