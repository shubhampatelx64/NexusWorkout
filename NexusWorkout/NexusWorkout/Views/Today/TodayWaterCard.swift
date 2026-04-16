//
//  TodayWaterCard.swift
//  NexusWorkout
//
//  8-cup water tracker (500 ml each → 4 L target).  Tapping a cup
//  fills up to that index; tapping a filled cup empties from that
//  index onward.  Persists to DailyLog.waterLiters.
//
//  Why prominent: baseline panel showed elevated calcium-oxalate
//  crystals + mild dehydration (Na, Cl) — hydration is non-negotiable.
//

import SwiftUI

struct TodayWaterCard: View {
    @Bindable var log: DailyLog
    let onChange: () -> Void

    private static let cupVolume: Double =
        PlanTargets.waterLiters / Double(PlanTargets.waterCups)

    private var currentLiters: Double {
        log.waterLiters ?? 0
    }

    private var cupsConsumed: Int {
        let n = (currentLiters / Self.cupVolume).rounded()
        return min(PlanTargets.waterCups, max(0, Int(n)))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack {
                Text("Water")
                    .font(DS.Font.titleMedium)
                    .foregroundStyle(DS.Color.textPrimary)
                Spacer()
                Text("\(formattedLiters) / \(formattedTarget) L")
                    .font(DS.Font.captionEmphasised)
                    .foregroundStyle(DS.Color.textSecondary)
                    .monospacedDigit()
            }

            HStack(spacing: DS.Spacing.xs) {
                ForEach(0..<PlanTargets.waterCups, id: \.self) { i in
                    Button {
                        toggle(cupIndex: i)
                    } label: {
                        Image(systemName: i < cupsConsumed ? "drop.fill" : "drop")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(i < cupsConsumed
                                             ? DS.Color.chartTertiary
                                             : DS.Color.textSecondary.opacity(0.55))
                            .frame(maxWidth: .infinity, minHeight: 36)
                    }
                    .buttonStyle(.plain)
                }
            }
            .sensoryFeedback(.impact(weight: .light), trigger: cupsConsumed)
        }
        .dsCard()
    }

    private func toggle(cupIndex i: Int) {
        // Tap an empty cup at index i → fill to i+1 cups.
        // Tap a filled cup at index i → empty back down to i cups.
        let newCount = (i < cupsConsumed) ? i : (i + 1)
        log.waterLiters = (Double(newCount) * Self.cupVolume).rounded(toPlaces: 2)
        onChange()
    }

    private var formattedLiters: String {
        String(format: "%.1f", currentLiters)
    }

    private var formattedTarget: String {
        String(format: "%.1f", PlanTargets.waterLiters)
    }
}

private extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let p = pow(10.0, Double(places))
        return (self * p).rounded() / p
    }
}
