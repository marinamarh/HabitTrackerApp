//
//  Day.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 23.09.2026.
//

import SwiftUI

struct Day: Identifiable {
    var id: Date { date }
    var value: Int
    var weekdaySymbol: String
    var date: Date
    var notFromThisMonth: Bool = false
}
