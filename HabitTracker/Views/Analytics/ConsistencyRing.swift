//
//  ConsistencyRing.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 27.07.2026.
//

import SwiftUI

struct ConsistencyRing: View {
    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .stroke(Color.green.mix(with: .gray, by: 0.65), lineWidth: 14)
                .frame(width: 160, height: 160)

            VStack(spacing: 2) {
                Text("Consistency")
                    .font(.headline)

                Text("30-day completion across all habits")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}

#Preview {
    ConsistencyRing()
        .padding()
}
