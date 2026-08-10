//
//  HabitFrequency.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 12.07.2026.
//

import Foundation

enum HabitFrequency: Codable, Hashable, Equatable {
    case daily
    case specificDays([Weekday])
    
    func includes(_ weekday: Weekday) -> Bool {
        switch self {
        case .daily:
            true
        case .specificDays(let days):
            days.contains(weekday)
        }
    }
}

enum Weekday: String, Codable, CaseIterable, Identifiable {
    
    case mon = "Mon", tue = "Tue", wed = "Wed", thu = "Thu", fri = "Fri", sat = "Sat", sun = "Sun"
    
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .mon: String(localized: "Mon", comment: "Abbreviated Monday, shown in the weekday picker")
        case .tue: String(localized: "Tue", comment: "Abbreviated Tuesday, shown in the weekday picker")
        case .wed: String(localized: "Wed", comment: "Abbreviated Wednesday, shown in the weekday picker")
        case .thu: String(localized: "Thu", comment: "Abbreviated Thursday, shown in the weekday picker")
        case .fri: String(localized: "Fri", comment: "Abbreviated Friday, shown in the weekday picker")
        case .sat: String(localized: "Sat", comment: "Abbreviated Saturday, shown in the weekday picker")
        case .sun: String(localized: "Sun", comment: "Abbreviated Sunday, shown in the weekday picker")
        }
    }
    
    var calendarWeekday: Int {
        switch self {
        case .sun: 1
        case .mon: 2
        case .tue: 3
        case .wed: 4
        case .thu: 5
        case .fri: 6
        case .sat: 7
        }
    }
    
    init(date: Date, calendar: Calendar = .current) {
        switch calendar.component(.weekday, from: date) {
        case 1: self = .sun
        case 2: self = .mon
        case 3: self = .tue
        case 4: self = .wed
        case 5: self = .thu
        case 6: self = .fri
        default: self = .sat
        }
    }
}
