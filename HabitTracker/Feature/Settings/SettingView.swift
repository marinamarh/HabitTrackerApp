//
//  SettingView.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 05.08.2026.
//

import SwiftUI
import StoreKit

enum AppTheme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var displayName: String {
        switch self {
        case .system: String(localized: "System", comment: "Appearance option: follow system light/dark setting")
        case .light: String(localized: "Light", comment: "Appearance option: always light")
        case .dark: String(localized: "Dark", comment: "Appearance option: always dark")
        }
    }
}


struct SettingView: View {
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .system
    
    @Environment(\.requestReview) private var requestReview
    @Environment(\.scenePhase) private var scenePhase
    @Environment(NotificationService.self) private var notificationService
    
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    private var currentLanguageDisplayName: String {
        guard let code = Locale.current.language.languageCode?.identifier else { return "" }
        return Locale.current.localizedString(forLanguageCode: code)?.capitalized ?? code
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Picker(selection: $selectedTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    } label: {
                        Label("Appearance", systemImage: "circle.lefthalf.filled")
                    }
                    
                    Button {
                        openSystemSettings()
                    } label: {
                        HStack {
                            Label("Language", systemImage: "globe")
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(currentLanguageDisplayName)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Button {
                        openSystemSettings()
                    } label: {
                        HStack {
                            Label("Notifications", systemImage: "bell.badge")
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(notificationService.permission == .authorized ? "On" : "Off")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section("Support & Feedback") {
                    Button {
                        requestReview()
                    } label: {
                        Label("Rate Us", systemImage: "star")
                            .foregroundStyle(.primary)
                    }
                    
                    Link(destination: URL(string: "https://example.com/privacy-policy")!) {
                        Label("Privacy Policy", systemImage: "lock.shield")
                            .foregroundStyle(.primary)
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Marina Marhitych")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .task {
                await notificationService.refreshPermission()
            }
            .onChange(of: scenePhase) { _, newPhase in
                guard newPhase == .active else { return }
                Task { await notificationService.refreshPermission() }
            }
        }
    }
    
    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

#Preview {
    SettingView()
        .environment(NotificationService())
}
