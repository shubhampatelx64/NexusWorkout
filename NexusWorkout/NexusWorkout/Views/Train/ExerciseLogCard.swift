//
//  ExerciseLogCard.swift
//  NexusWorkout
//
//  One card per lift inside ActiveSessionView.  Header shows the
//  target (sets × rep-range); body lists each LoggedSet via SetLogRow;
//  footer is an "Add Set" button that copies the previous set's
//  weight / reps as the starting values (handled by the parent).
//

import SwiftUI

struct ExerciseLogCard: View {
    @Bindable var loggedExercise: LoggedExercise

    let targetSets: Int
    let targetRange: ClosedRange<Int>
    let onAddSet: () -> Void
    let onCompleteSet: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(loggedExercise.exercise?.name ?? "—")
                        .font(DS.Font.titleMedium)
                        .foregroundStyle(DS.Color.textPrimary)
                    Text("Target: \(targetSets) × \(targetRange.lowerBound)–\(targetRange.upperBound)")
                        .font(DS.Font.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                }
                Spacer()
                Text("\(completedCount) / \(targetSets)")
                    .font(DS.Font.bodyEmphasised)
                    .foregroundStyle(completedCount >= targetSets
                                     ? DS.Color.accentPrimary
                                     : DS.Color.textSecondary)
                    .monospacedDigit()
            }

            if sortedSets.isEmpty {
                Text("No sets logged yet — tap Add Set to start.")
                    .font(DS.Font.caption)
                    .foregroundStyle(DS.Color.textSecondary)
            } else {
                VStack(spacing: 4) {
                    ForEach(sortedSets, id: \.id) { set in
                        SetLogRow(set: set, onComplete: onCompleteSet)
                    }
                }
            }

            Button(action: onAddSet) {
                Label("Add Set", systemImage: "plus.circle.fill")
                    .font(DS.Font.bodyEmphasised)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DS.Spacing.xs)
                    .background(DS.Color.surfaceElevated)
                    .foregroundStyle(DS.Color.accentPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .dsCard()
    }

    private var sortedSets: [LoggedSet] {
        loggedExercise.sets.sorted { $0.setNumber < $1.setNumber }
    }

    /// A set "counts" once weight and reps are both > 0.  Good enough
    /// for showing progress to target — the real PR / volume math
    /// lives on the Progress tab (P1.6).
    private var completedCount: Int {
        sortedSets.filter { $0.weight > 0 && $0.reps > 0 }.count
    }
}
