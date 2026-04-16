//
//  ReminderEditorView.swift
//  NexusWorkout
//
//  Sheet for editing one ReminderConfig.  Changes save to SwiftData
//  and re-sync UNUserNotificationCenter on tap of Save — the rest
//  of Settings holds a @Bindable reference so toggles flip live.
//
//  Days-of-week chips use ISO numbering (1=Mon..7=Sun) to match
//  WorkoutTemplate / MealTemplate / NotificationService.
//

import SwiftUI
import SwiftData

struct ReminderEditorView: View {
    @Bindable var config: ReminderConfig
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss)      private var dismiss

    @Query(sort: \ReminderConfig.time)
    private var allReminders: [ReminderConfig]

    @State private var pickerDate: Date = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Title", text: $config.title)
                    TextField("Body",  text: $config.body, axis: .vertical)
                        .lineLimit(1...3)
                }

                Section("Time") {
                    DatePicker(
                        "Fires at",
                        selection: $pickerDate,
                        displayedComponents: .hourAndMinute
                    )
                }

                Section("Days") {
                    daysChipRow
                    HStack(spacing: DS.Spacing.sm) {
                        Button("Every day") { config.daysOfWeek = Array(1...7) }
                        Button("Weekdays")  { config.daysOfWeek = [1,2,3,4,5] }
                        Button("Weekends")  { config.daysOfWeek = [6,7] }
                    }
                    .buttonStyle(.bordered)
                    .font(DS.Font.caption)
                }

                Section {
                    Toggle("Enabled", isOn: $config.enabled)
                        .tint(DS.Color.accentPrimary)
                }
            }
            .navigationTitle("Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
            .onAppear {
                pickerDate = parseTime(config.time) ?? Date()
            }
        }
    }

    // MARK: - Days chips

    private var daysChipRow: some View {
        HStack(spacing: DS.Spacing.xxs) {
            ForEach(1...7, id: \.self) { day in
                let isOn = config.daysOfWeek.contains(day)
                Button {
                    toggle(day: day)
                } label: {
                    Text(shortLabel(day))
                        .font(DS.Font.captionEmphasised)
                        .frame(width: 36, height: 32)
                        .background(isOn ? DS.Color.accentPrimary : DS.Color.surfaceElevated)
                        .foregroundStyle(isOn ? DS.Color.background : DS.Color.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func toggle(day: Int) {
        if let idx = config.daysOfWeek.firstIndex(of: day) {
            config.daysOfWeek.remove(at: idx)
        } else {
            config.daysOfWeek = (config.daysOfWeek + [day]).sorted()
        }
    }

    private func shortLabel(_ day: Int) -> String {
        ["M","T","W","T","F","S","S"][max(0, min(6, day - 1))]
    }

    // MARK: - Time parsing

    private func parseTime(_ s: String) -> Date? {
        let parts = s.split(separator: ":")
        guard parts.count == 2,
              let h = Int(parts[0]),
              let m = Int(parts[1]) else { return nil }
        var comps = DateComponents()
        comps.hour = h
        comps.minute = m
        return Calendar.current.date(from: comps)
    }

    private func formattedTime(_ date: Date) -> String {
        let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
        return String(format: "%02d:%02d", comps.hour ?? 0, comps.minute ?? 0)
    }

    // MARK: - Save

    private func save() {
        config.time = formattedTime(pickerDate)
        try? context.save()
        Task {
            await NotificationService.sync(configs: allReminders, context: context)
            await MainActor.run { dismiss() }
        }
    }
}
