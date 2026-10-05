//
//  FirstLaunch.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 05.10.2026.
//

import Foundation

enum FirstLaunch {
    private static let key = "firstLaunchDate"
    
    static var date: Date {
        if let saved = UserDefaults.standard.object(forKey: key) as? Date {
            return saved
        }
        let now = Date.now
        UserDefaults.standard.set(now, forKey: key)
        return now
    }
}
