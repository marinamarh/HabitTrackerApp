//
//  ConsistencyRing.swift
//  HabitTracker
//
//  Created by Marina Marhitych on 27.07.2026.
//

import SwiftUI

struct ConsistencyRing: View {
    let percentage: Int
    
    private var progress: Double {
        min(max(Double(percentage) / 100, 0), 1)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.sageGreen.opacity(0.2), lineWidth: 14)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.sageGreen, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: progress)
                
                Text(Double(percentage) / 100, format: .percent.precision(.fractionLength(0)))
                    .font(.system(.title, design: .serif))
                    .bold()
            }
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
    VStack(spacing: 20) {
        ConsistencyRing(percentage: 74)
        ConsistencyRing(percentage: 0)
        ConsistencyRing(percentage: 100)
    }
    .padding()
}
