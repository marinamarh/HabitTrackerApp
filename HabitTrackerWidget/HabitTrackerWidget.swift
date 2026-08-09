//
//  HabitTrackerWidget.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 07.08.2026.
//

import WidgetKit
import SwiftUI

struct HabitTrackerWidget: Widget {
    let kind: String = AppGroup.widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitsProvider()) { entry in
            HabitTrackerWidgetView(entry: entry)
        }
        .configurationDisplayName("Today's Habits")
        .description("See which habits are left for today.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct HabitTrackerWidgetBundle: WidgetBundle {
    var body: some Widget {
        HabitTrackerWidget()
    }
}
