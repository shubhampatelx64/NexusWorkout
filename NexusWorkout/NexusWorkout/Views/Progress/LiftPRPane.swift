//
//  LiftPRPane.swift
//  NexusWorkout
//
//  Estimated-1RM leaderboard derived from LoggedSets across every
//  completed session.  The Epley formula (w × (1 + reps/30)) is the
//  one most commonly cited in strength-coaching literature and works
//  well for the 1-12 rep range this plan lives in.  Warmup sets and
//  zero-weight / zero-rep sets are excluded.
//
//  Rows are sorted by estimated 1RM descending so the heaviest lifts
//  surface first; each row shows the actual weight × reps that set
//  the PR plus the computed 1RM.
//

import SwiftUI
import SwiftData

struct LiftPRPane: View {
    @Query private var sessions: [WorkoutSession]

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.md) {
                summaryCard
                if personalRecords.isEmpty {
                    emptyState
                } else {
                    ForEach(personalRecords, id: \.exerciseID) { pr in
                        prRow(pr)
                    }
                }
            }
            .padding(DS.Spacing.md)
        }
    }

    // MARK: - Subviews

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
            Text("Personal records")
                .font(DS.Font.captionEmphasised)
                .foregroundStyle(DS.Color.textSecondary)
                .textCase(.uppercase)
            HStack(alignment: .firstTextBaseline) {
                Text("\(personalRecords.count)")
                    .font(DS.Font.displaySmall)
                    .foregroundStyle(DS.Color.textPrimary)
                    .monospacedDigit()
                Text("lifts tracked")
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textSecondary)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    private var emptyState: some View {
        VStack(spacing: DS.Spacing.xs) {
            Image(systemName: "trophy")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(DS.Color.accentPrimary)
            Text("No PRs yet")
                .font(DS.Font.titleMedium)
                .foregroundStyle(DS.Color.textPrimary)
            Text("Log a working set in the Train tab and your best estimated-1RM per lift lands here.")
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.Spacing.lg)
        .dsCard()
    }

    @ViewBuilder
    private func prRow(_ pr: PR) -> some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(pr.exerciseName)
                    .font(DS.Font.titleMedium)
                    .foregroundStyle(DS.Color.textPrimary)
                Text("\(formatted(pr.weight)) kg × \(pr.reps) · \(format(date: pr.date))")
                    .font(DS.Font.caption)
                    .foregroundStyle(DS.Color.textSecondary)
                    .monospacedDigit()
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(formatted(pr.estimated1RM)) kg")
                    .font(DS.Font.displaySmall)
                    .foregroundStyle(DS.Color.accentPrimary)
                    .monospacedDigit()
                Text("est. 1RM")
                    .font(DS.Font.caption)
                    .foregroundStyle(DS.Color.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    // MARK: - Derived

    private struct PR {
        let exerciseID: UUID
        let exerciseName: String
        let weight: Double
        let reps: Int
        let date: Date
        let estimated1RM: Double
    }

    private var personalRecords: [PR] {
        var best: [UUID: PR] = [:]
        for session in sessions where session.completed {
            for lx in session.loggedExercises {
                guard let exercise = lx.exercise else { continue }
                for set in lx.sets where !set.isWarmup && set.weight > 0 && set.reps > 0 {
                    let e1rm = set.weight * (1.0 + Double(set.reps) / 30.0)
                    if let current = best[exercise.id], current.estimated1RM >= e1rm { continue }
                    best[exercise.id] = PR(
                        exerciseID: exercise.id,
                        exerciseName: exercise.name,
                        weight: set.weight,
                        reps: set.reps,
                        date: set.completedAt,
                        estimated1RM: e1rm
                    )
                }
            }
        }
        return best.values.sorted { $0.estimated1RM > $1.estimated1RM }
    }

    private func formatted(_ kg: Double) -> String {
        kg.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", kg)
            : String(format: "%.1f", kg)
    }

    private func format(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "d MMM"
        return f.string(from: date)
    }
}
