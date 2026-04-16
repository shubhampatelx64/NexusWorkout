//
//  SupplementsPane.swift
//  NexusWorkout
//
//  Today's supplement checklist.  Six items, sorted by suggested
//  time-of-day so the morning stack reads first.  Tapping toggles a
//  SupplementLog row for today; the summary card up top tracks
//  "X / Y taken" as the user works through the list.
//

import SwiftUI
import SwiftData

struct SupplementsPane: View {
    @Query(sort: \SupplementSchedule.timeOfDay)
    private var allSchedules: [SupplementSchedule]

    @Query(sort: \SupplementLog.date, order: .reverse)
    private var allLogs: [SupplementLog]

    @Environment(\.modelContext) private var context

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.md) {
                summaryCard
                ForEach(enabledSchedules, id: \.id) { sup in
                    SupplementRow(
                        schedule: sup,
                        isTaken: isTakenToday(sup),
                        onToggle: { toggleTaken(sup) }
                    )
                }
            }
            .padding(DS.Spacing.md)
        }
    }

    // MARK: - Subviews

    private var summaryCard: some View {
        let taken = enabledSchedules.filter(isTakenToday).count
        let total = enabledSchedules.count
        return VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Text("Today")
                .font(DS.Font.captionEmphasised)
                .foregroundStyle(DS.Color.textSecondary)
                .textCase(.uppercase)
            HStack(alignment: .firstTextBaseline) {
                Text("\(taken) / \(total)")
                    .font(DS.Font.displaySmall)
                    .foregroundStyle(DS.Color.textPrimary)
                    .monospacedDigit()
                Text("supplements taken")
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textSecondary)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    // MARK: - Derived

    private var enabledSchedules: [SupplementSchedule] {
        allSchedules
            .filter { $0.enabled }
            .sorted { ($0.timeOfDay ?? "99:99") < ($1.timeOfDay ?? "99:99") }
    }

    private var todaysLogs: [SupplementLog] {
        allLogs.filter {
            Calendar.current.isDate($0.date, inSameDayAs: .now)
        }
    }

    private func isTakenToday(_ schedule: SupplementSchedule) -> Bool {
        todaysLogs.contains(where: {
            $0.supplement?.id == schedule.id && $0.taken
        })
    }

    // MARK: - Actions

    private func toggleTaken(_ schedule: SupplementSchedule) {
        if let existing = todaysLogs.first(where: { $0.supplement?.id == schedule.id }) {
            existing.taken.toggle()
            if !existing.taken { context.delete(existing) }
        } else {
            let new = SupplementLog(
                date: .now,
                supplement: schedule,
                taken: true
            )
            context.insert(new)
        }
        try? context.save()
    }
}
