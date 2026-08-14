//
//  StreakCard.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 27.07.2026.
//

import SwiftUI

struct StreakCard: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(value)")
                .font(.system(.title, design: .serif))
            
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}

#Preview {
    HStack(spacing: 12) {
        StreakCard(value: 26, label: "Current best streak")
        StreakCard(value: 26, label: "Longest ever, in days")
    }
    .padding()
}
