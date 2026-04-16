//
//  TodayJournalCard.swift
//  NexusWorkout
//
//  Two-row daily journal.  Sleep is a stepper (0–12 h, 0.5 h grain);
//  energy is a 1–10 menu picker.  Both write through to the same
//  DailyLog the water card edits — `onChange` triggers a save.
//
//  Kept minimal on purpose — full mood / hunger / step capture lives
//  on a Settings → Journal sheet later (P1.8); this card is for
//  "fill it in five seconds before bed".
//

import SwiftUI

struct TodayJournalCard: View {
    @Bindable var log: DailyLog
    let onChange: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("Journal")
                .font(DS.Font.titleMedium)
                .foregroundStyle(DS.Color.textPrimary)

            VStack(spacing: DS.Spacing.sm) {
                sleepRow
                Divider().background(DS.Color.surfaceElevated)
                energyRow
            }
        }
        .dsCard()
    }

    // MARK: - Rows

    private var sleepRow: some View {
        HStack(spacing: DS.Spacing.sm) {
            Image(systemName: "moon.fill")
                .foregroundStyle(DS.Color.chartTertiary)
                .frame(width: 22)
            Text("Sleep")
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textPrimary)
            Spacer()
            Text(sleepText)
                .font(DS.Font.bodyEmphasised)
                .foregroundStyle(DS.Color.textPrimary)
                .monospacedDigit()
                .frame(minWidth: 56, alignment: .trailing)
            Stepper("", value: sleepBinding, in: 0...12, step: 0.5)
                .labelsHidden()
        }
    }

    private var energyRow: some View {
        HStack(spacing: DS.Spacing.sm) {
            Image(systemName: "bolt.fill")
                .foregroundStyle(DS.Color.warning)
                .frame(width: 22)
            Text("Energy")
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textPrimary)
            Spacer()
            energyPicker
        }
    }

    // MARK: - Helpers

    private var sleepBinding: Binding<Double> {
        Binding(
            get: { log.sleepHours ?? 0 },
            set: { v in
                log.sleepHours = v
                onChange()
            }
        )
    }

    private var sleepText: String {
        guard let s = log.sleepHours, s > 0 else { return "—" }
        return String(format: "%.1f h", s)
    }

    private var energyPicker: some View {
        Menu {
            ForEach((1...10).reversed(), id: \.self) { value in
                Button("\(value) / 10") {
                    log.energy = value
                    onChange()
                }
            }
            Divider()
            Button("Clear", role: .destructive) {
                log.energy = nil
                onChange()
            }
        } label: {
            Text(log.energy.map { "\($0) / 10" } ?? "Tap to log")
                .font(DS.Font.bodyEmphasised)
                .foregroundStyle(DS.Color.accentPrimary)
        }
    }
}
