//
//  TodayMacrosCard.swift
//  NexusWorkout
//
//  Today's macros vs. plan target — calories in the header, then a
//  per-macro horizontal bar (protein / carbs / fat).  Bars cap at 100 %
//  so users can see overshoot in the numeric line without the bar
//  visually misleading them.
//

import SwiftUI

struct TodayMacrosCard: View {
    let consumed: MacroTotals

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack {
                Text("Macros")
                    .font(DS.Font.titleMedium)
                    .foregroundStyle(DS.Color.textPrimary)
                Spacer()
                Text("\(consumed.calories) / \(PlanTargets.calories) kcal")
                    .font(DS.Font.captionEmphasised)
                    .foregroundStyle(DS.Color.textSecondary)
                    .monospacedDigit()
            }

            VStack(spacing: DS.Spacing.sm) {
                MacroBar(
                    label: "Protein",
                    value: consumed.protein,
                    target: PlanTargets.protein,
                    unit: "g",
                    tint: DS.Color.accentPrimary
                )
                MacroBar(
                    label: "Carbs",
                    value: consumed.carbs,
                    target: PlanTargets.carbs,
                    unit: "g",
                    tint: DS.Color.chartTertiary
                )
                MacroBar(
                    label: "Fat",
                    value: consumed.fat,
                    target: PlanTargets.fat,
                    unit: "g",
                    tint: DS.Color.warning
                )
            }
        }
        .dsCard()
    }
}

private struct MacroBar: View {
    let label: String
    let value: Double
    let target: Double
    let unit: String
    let tint: Color

    private var ratio: Double {
        guard target > 0 else { return 0 }
        return min(1, value / target)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
            HStack {
                Text(label)
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textPrimary)
                Spacer()
                Text("\(Int(value)) / \(Int(target)) \(unit)")
                    .font(DS.Font.captionEmphasised)
                    .foregroundStyle(DS.Color.textSecondary)
                    .monospacedDigit()
            }
            ProgressView(value: ratio)
                .progressViewStyle(.linear)
                .tint(tint)
        }
    }
}
