# HabitTracker

A native iOS habit tracker built with SwiftUI and SwiftData — track daily habits, see your progress in charts, and stay on track with reminders and a Home Screen widget.

> Portfolio project built solo to practice modern SwiftUI/SwiftData patterns for a Junior iOS Developer role.

//

## Features

- **Habit tracking** — create, edit, and delete habits with a custom icon, color, and daily or specific-weekday frequency
- **Custom infinite-scroll calendar** — horizontally scrolling week view for browsing past and upcoming days; habits can only be marked complete for today, but you can look back at your history or ahead at what's scheduled
- **Progress analytics** — current & longest streaks, weekly completion chart, and a monthly consistency ring, built with Swift Charts
- **Home Screen widget** — shows today's habits at a glance, powered by WidgetKit and a shared App Group container; stays in sync the moment you check something off in the app
- **Local reminders** — per-habit notifications, scheduled only for the days that habit is actually due
- **Onboarding flow** — short first-launch walkthrough for new users
- **Localization** — English and Ukrainian, via String Catalog
- **Light & dark mode** — fully native colors and materials, no hardcoded hex values

## Tech Stack

| Layer | Technology |
|---|---|
| UI | SwiftUI |
| Persistence | SwiftData |
| State management | Observation framework (`@Observable`) |
| Charts | Swift Charts |
| Widget | WidgetKit + App Group |
| Notifications | UserNotifications |
| Testing | Swift Testing (`@Test`, `#expect`) |
| Language | Swift 5, iOS 18.6+ |

## Architecture

The project follows a **feature-based folder structure** rather than grouping files by type (no `Views/`, `Models/`, `ViewModels/` at the root):

```
HabitTracker/
├── Feature/
│   ├── Habits/          — CRUD, daily list, custom calendar
│   ├── Analytics/        — streaks, charts, consistency ring
│   ├── Onboarding/        — first-launch flow
│   ├── Settings/          — appearance & notification settings
│   └── Components/       — small reusable views shared across features
├── Models/               — SwiftData @Model types, sample data
├── Services/              — NotificationService and related types
├── HabitTrackerApp.swift  — app entry point, deep link handling
└── MainTabView.swift      — tab navigation

HabitTrackerWidget/        — WidgetKit extension (separate target)
HabitTrackerTests/         — Swift Testing unit tests
```

**MVVM is applied selectively, not by default.** A `ViewModel` only exists where there's real data transformation to test in isolation — `AnalyticsViewModel` computes streaks and weekly completion percentages from raw `HabitEntry` data. Simple CRUD screens (`HabitList`, `AddHabitView`) read directly from SwiftData's `@Query` and write straight to `ModelContext`, following Apple's own idiomatic SwiftData approach — adding a ViewModel layer there would just be indirection with no benefit.

A couple of patterns worth calling out:

- **`AnalyticsViewModel` and `StreakCalculator` are stateless `struct`s / `enum`s**, not classes — they're pure functions over data the view already has via `@Query`, so there's no lifecycle to manage and no `onAppear` needed.
- **SwiftData can't persist enums with associated values directly.** `Habit.frequency: HabitFrequency` is backed by two private primitive stored properties (`frequencyIsDaily: Bool`, `specificWeekdaysRaw: [String]`) with a computed `get`/`set` that reconstructs the enum — this keeps the public API clean while staying queryable at the SQLite level.
- **The widget reads a separate `ModelContainer`** pointed at the same App Group as the main app. It never receives `@Model` objects directly — only plain snapshot structs (`HabitWidgetItem`) — since crossing the process boundary with a live SwiftData object isn't supported.

## Requirements

- Xcode 16 or later
- iOS 18.6+ (simulator or device)

## Getting Started

```bash
git clone https://github.com/marinamarh/HabitTrackerApp.git
cd HabitTrackerApp
open HabitTracker.xcodeproj
```

Build and run the `HabitTracker` scheme. The widget extension is bundled as a separate target and will build automatically.

> **Note:** the app and widget share data through an App Group (`group.mm.HabitTracker`). If you fork this project and want the widget to work, you'll need to create your own App Group in your Apple Developer account and update the identifier in both targets' entitlements.

## Testing

Run tests with `Cmd+U`, or:

```bash
xcodebuild test -scheme HabitTracker -destination 'platform=iOS Simulator,name=iPhone 16'
```
