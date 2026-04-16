//
//  SupplementRow.swift
//  NexusWorkout
//
//  One row in the supplements checklist.  Shows time-of-day, name,
//  dose and a timing pill (morning / with-food / etc) — the same
//  visual language as MealCard so the Eat tab feels cohesive.
//

import SwiftUI

struct SupplementRow: View {
    let schedule: SupplementSchedule
    let isTaken: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: DS.Spacing.sm) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: DS.Spacing.xs) {
                    Text(schedule.timeOfDay ?? "—")
                        .font(DS.Font.captionEmphasised)
                        .foregroundStyle(DS.Color.textSecondary)
                        .monospacedDigit()
                    Text(schedule.timing)
                        .font(DS.Font.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 1)
                        .background(DS.Color.surfaceElevated)
                        .clipShape(Capsule())
                }
                Text(schedule.name)
                    .font(DS.Font.titleMedium)
                    .foregroundStyle(DS.Color.textPrimary)
                Text(schedule.dose)
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textSecondary)
            }
            Spacer()
            Button(action: onToggle) {
                Image(systemName: isTaken ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundStyle(isTaken
                                     ? DS.Color.accentPrimary
                                     : DS.Color.textSecondary)
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: isTaken)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
        .opacity(isTaken ? 0.85 : 1)
    }
}
