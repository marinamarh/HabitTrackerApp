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
