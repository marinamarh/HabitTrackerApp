//
//  NotificationPermission.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 06.08.2026.
//

import UserNotifications

enum NotificationPermission {
    case notDetermined
    case authorized
    case denied
    
    init(_ status: UNAuthorizationStatus) {
        switch status {
        case .authorized, .provisional, .ephemeral: self = .authorized
        case .denied: self = .denied
        default: self = .notDetermined
        }
    }
}
