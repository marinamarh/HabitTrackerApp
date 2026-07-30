//
//  DailyProgressBar.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 29.07.2026.
//


import SwiftUI

struct DailyProgressBar: View {
    let completedCount: Int
    let totalCount: Int
    
    private var progress: CGFloat {
        guard totalCount > 0 else { return 0 }
        return CGFloat(completedCount) / CGFloat(totalCount)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                    
                    Capsule()
                        .fill(Color.sageGreen)
                        .frame(width: proxy.size.width * progress)
                }
            }
            .frame(height: 6)
            
            Text("\(completedCount) of \(totalCount) done")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .fixedSize()
        }
    }
}

#Preview {
    DailyProgressBar(completedCount: 2, totalCount: 6)
        .padding()
}
