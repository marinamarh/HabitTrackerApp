import Foundation

struct WeekPage: Identifiable, Equatable {
    let id: Date
    let slots: [Date?]
}