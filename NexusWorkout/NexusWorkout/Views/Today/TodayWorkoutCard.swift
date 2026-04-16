//
//  TodayWorkoutCard.swift
//  NexusWorkout
//
//  Today's scheduled workout from the 5-day split.  Shows the first
//  four exercises as a preview; the "Start Workout" CTA is wired in
//  P1.4 (Train tab).  If today isn't a lifting day, renders a
//  short "rest day" copy block instead.
//

import SwiftUI

struct TodayWorkoutCard: View {
    let template: WorkoutTemplate?

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack {
                Text("Today's Workout")
                    .font(DS.Font.titleMedium)
                    .foregroundStyle(DS.Color.textPrimary)
                Spacer()
                Image(systemName: "dumbbell.fill")
                    .foregroundStyle(DS.Color.accentPrimary)
            }
            if let template {
                content(for: template)
            } else {
                restDay
            }
        }
        .dsCard()
    }

    @ViewBuilder
    private func content(for template: WorkoutTemplate) -> some View {
        Text(template.name)
            .font(DS.Font.displaySmall)
            .foregroundStyle(DS.Color.textPrimary)

        if let notes = template.notes, !notes.isEmpty {
            Text(notes)
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textSecondary)
        }

        VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
            let preview = template.exercises
                .sorted(by: { $0.order < $1.order })
                .prefix(4)
            ForEach(Array(preview), id: \.id) { row in
                HStack {
                    Text("\(row.order).")
                        .foregroundStyle(DS.Color.textSecondary)
                        .monospacedDigit()
                        .frame(width: 22, alignment: .leading)
                    Text(row.exercise?.name ?? "—")
                        .foregroundStyle(DS.Color.textPrimary)
                        .lineLimit(1)
                    Spacer()
                    Text("\(row.targetSets) × \(row.repRangeLow)-\(row.repRangeHigh)")
                        .foregroundStyle(DS.Color.textSecondary)
                        .monospacedDigit()
                }
                .font(DS.Font.body)
            }
            if template.exercises.count > 4 {
                Text("+ \(template.exercises.count - 4) more")
                    .font(DS.Font.caption)
                    .foregroundStyle(DS.Color.textSecondary)
                    .padding(.leading, 22)
            }
        }
        .padding(.top, DS.Spacing.xxs)

        Button {
            // Wired in P1.4 — opens the active logger.
        } label: {
            Label("Start Workout", systemImage: "play.fill")
                .font(DS.Font.bodyEmphasised)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DS.Spacing.sm)
                .background(DS.Color.accentPrimary)
                .foregroundStyle(DS.Color.background)
                .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(true)
        .opacity(0.55)
    }

    private var restDay: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Text("Rest day")
                .font(DS.Font.displaySmall)
                .foregroundStyle(DS.Color.textPrimary)
            Text("Active recovery: 30-min Zone 2 walk + light mobility. Hit your protein and water.")
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textSecondary)
        }
    }
}
