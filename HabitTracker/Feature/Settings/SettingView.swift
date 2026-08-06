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
}

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case ukrainian = "Українська"
}

struct SettingView: View {
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .system
    @AppStorage("selectedLanguage") private var selectedLanguage: AppLanguage = .english
    
    @Environment(\.requestReview) private var requestReview
    
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Picker(selection: $selectedTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    } label: {
                        Label("Appearance", systemImage: "circle.lefthalf.filled")
                    }
                    
                    Picker(selection: $selectedLanguage) {
                        ForEach(AppLanguage.allCases, id: \.self) { lang in
                            Text(lang.rawValue).tag(lang)
                        }
                    } label: {
                        Label("Language", systemImage: "globe")
                    }
                    
                    Button {
                        openSystemSettings()
                    } label: {
                        Label("Notifications", systemImage: "bell.badge")
                            .foregroundStyle(.primary)
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
        }
    }
    
    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

#Preview {
    SettingView()
}
