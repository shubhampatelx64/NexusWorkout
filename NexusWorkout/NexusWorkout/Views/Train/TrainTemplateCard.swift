//
//  TrainTemplateCard.swift
//  NexusWorkout
//
//  List-row card for a WorkoutTemplate in the Train browser.  Shows
//  the template name, weekday chip, notes preview, and a bottom row
//  with lift count + a rough time estimate (avg rest + ~45 s working
//  per set).  Tap-target is the entire card via the parent
//  NavigationLink.
//

import SwiftUI

struct TrainTemplateCard: View {
    let template: WorkoutTemplate

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack(alignment: .top) {
                Text(template.name)
                    .font(DS.Font.titleMedium)
                    .foregroundStyle(DS.Color.textPrimary)
                Spacer()
                if let day = template.dayOfWeek {
                    Text(weekdayLabel(day))
                        .font(DS.Font.captionEmphasised)
                        .foregroundStyle(DS.Color.textSecondary)
                        .padding(.horizontal, DS.Spacing.xs)
                        .padding(.vertical, 2)
                        .background(DS.Color.surfaceElevated)
                        .clipShape(Capsule())
                }
            }

            if let notes = template.notes, !notes.isEmpty {
                Text(notes)
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .lineLimit(2)
            }

            HStack(spacing: DS.Spacing.md) {
                Label("\(template.exercises.count) lifts", systemImage: "list.bullet")
                Label("~\(estimatedMinutes) min", systemImage: "clock")
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(DS.Color.textSecondary)
            }
            .font(DS.Font.caption)
            .foregroundStyle(DS.Color.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    private var estimatedMinutes: Int {
        let totalSets = template.exercises.reduce(0) { $0 + $1.targetSets }
        let count     = max(1, template.exercises.count)
        let avgRest   = template.exercises.map(\.restSeconds).reduce(0, +) / count
        let perSet    = avgRest + 45    // ~45 s of working time per set
        return max(20, (totalSets * perSet) / 60)
    }

    private func weekdayLabel(_ iso: Int) -> String {
        let names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return names[max(0, min(6, iso - 1))]
    }
}
