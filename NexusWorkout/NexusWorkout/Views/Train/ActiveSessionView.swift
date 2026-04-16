//
//  ActiveSessionView.swift
//  NexusWorkout
//
//  Live workout logger.  Created with a WorkoutTemplate; on first
//  appear it materialises a WorkoutSession and one LoggedExercise per
//  TemplateExercise, then lets the user log sets in real time.
//
//  Layout:
//      • elapsed-time header (TimelineView, 1 s tick)
//      • one ExerciseLogCard per lift (sets + add-set + complete)
//      • Finish Workout button at the bottom
//      • Floating RestTimerBanner overlays from the bottom while a
//        rest interval is active
//
//  No "cancel" affordance for now — backing out keeps the in-progress
//  session.  Finish marks `completed = true` and computes duration.
//

import SwiftUI
import SwiftData

struct ActiveSessionView: View {
    let template: WorkoutTemplate

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss)      private var dismiss

    @State private var session:        WorkoutSession?
    @State private var loggedExercises: [LoggedExercise] = []
    @State private var startTime:      Date  = .now

    @State private var restEndTime:    Date? = nil
    @State private var restTotalSecs:  Int   = 0

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.md) {
                header
                ForEach(loggedExercises, id: \.id) { logEx in
                    ExerciseLogCard(
                        loggedExercise: logEx,
                        targetSets:  targetSets(for: logEx),
                        targetRange: targetRange(for: logEx),
                        onAddSet:    { addSet(to: logEx) },
                        onCompleteSet: { startRestTimer(for: logEx) }
                    )
                }
                finishButton
                Spacer(minLength: restEndTime == nil ? 0 : 80)
            }
            .padding(DS.Spacing.md)
        }
        .dsBackground()
        .overlay(alignment: .bottom) {
            if let endTime = restEndTime {
                RestTimerBanner(
                    endTime: endTime,
                    totalSeconds: restTotalSecs,
                    onSkip: { restEndTime = nil }
                )
                .padding(DS.Spacing.md)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(DS.Motion.standard, value: restEndTime)
        .navigationTitle(template.name)
        .navigationBarTitleDisplayMode(.inline)
        .task { ensureSession() }
    }

    // MARK: - Header / footer

    private var header: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let elapsed = Int(context.date.timeIntervalSince(startTime))
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("In progress")
                        .font(DS.Font.captionEmphasised)
                        .foregroundStyle(DS.Color.textSecondary)
                        .textCase(.uppercase)
                    Text(template.name)
                        .font(DS.Font.titleMedium)
                        .foregroundStyle(DS.Color.textPrimary)
                }
                Spacer()
                Text(formatElapsed(elapsed))
                    .font(DS.Font.displaySmall)
                    .foregroundStyle(DS.Color.accentPrimary)
                    .monospacedDigit()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .dsCard()
        }
    }

    private var finishButton: some View {
        Button(action: finishWorkout) {
            Label("Finish Workout", systemImage: "checkmark.circle.fill")
                .font(DS.Font.bodyEmphasised)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DS.Spacing.sm)
                .background(DS.Color.accentPrimary)
                .foregroundStyle(DS.Color.background)
                .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Session bootstrap

    private func ensureSession() {
        if session != nil { return }

        let s = WorkoutSession(date: .now, template: template)
        context.insert(s)

        let rows = template.exercises.sorted { $0.order < $1.order }
        var legs: [LoggedExercise] = []
        for (i, tex) in rows.enumerated() {
            guard let ex = tex.exercise else { continue }
            let le = LoggedExercise(exercise: ex, order: i + 1)
            le.session = s
            s.loggedExercises.append(le)
            legs.append(le)
        }
        try? context.save()

        session         = s
        loggedExercises = legs
        startTime       = .now
    }

    // MARK: - Target lookup

    private func templateRow(for logEx: LoggedExercise) -> TemplateExercise? {
        guard let name = logEx.exercise?.name else { return nil }
        return template.exercises.first { $0.exercise?.name == name }
    }

    private func targetSets(for logEx: LoggedExercise) -> Int {
        templateRow(for: logEx)?.targetSets ?? 3
    }

    private func targetRange(for logEx: LoggedExercise) -> ClosedRange<Int> {
        guard let row = templateRow(for: logEx) else { return 8...12 }
        return row.repRangeLow...row.repRangeHigh
    }

    // MARK: - Mutations

    private func addSet(to logEx: LoggedExercise) {
        let last = logEx.sets.sorted(by: { $0.setNumber < $1.setNumber }).last
        let next = LoggedSet(
            setNumber: (last?.setNumber ?? 0) + 1,
            weight: last?.weight ?? 0,
            reps:   last?.reps   ?? 0
        )
        next.loggedExercise = logEx
        logEx.sets.append(next)
        try? context.save()
    }

    private func startRestTimer(for logEx: LoggedExercise) {
        guard let row = templateRow(for: logEx), row.restSeconds > 0 else { return }
        restTotalSecs = row.restSeconds
        restEndTime   = Date().addingTimeInterval(TimeInterval(row.restSeconds))
    }

    private func finishWorkout() {
        guard let s = session else { return }
        s.completed         = true
        s.durationMinutes   = max(1, Int(Date().timeIntervalSince(startTime) / 60))
        try? context.save()
        dismiss()
    }

    // MARK: - Helpers

    private func formatElapsed(_ secs: Int) -> String {
        String(format: "%02d:%02d", secs / 60, secs % 60)
    }
}
