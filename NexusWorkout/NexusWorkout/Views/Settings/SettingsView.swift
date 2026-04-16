//
//  SettingsView.swift
//  NexusWorkout
//
//  Push-navigation destination opened from a gear icon in the
//  Today toolbar.  Four sections:
//    Profile    — static biodata from UserProfile
//    Plan       — day / week progress, reset start-date
//    Reminders  — live ReminderConfig list, each tap opens editor
//    Data       — JSON export via ShareLink, wipe-all escape hatch
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query(sort: \ReminderConfig.time) private var reminders: [ReminderConfig]
    @Environment(\.modelContext) private var context

    @State private var exportURL: URL?
    @State private var showWipeConfirm = false
    @State private var editing: ReminderConfig?

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.md) {
                profileCard
                planCard
                remindersCard
                dataCard
                aboutCard
            }
            .padding(DS.Spacing.md)
        }
        .dsBackground()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: editingBinding) {
            if let editing { ReminderEditorView(config: editing) }
        }
        .confirmationDialog(
            "Delete all logged data?",
            isPresented: $showWipeConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete everything", role: .destructive) { wipeAll() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Clears workouts, meal logs, supplements, body metrics, photos, and journal entries. Templates and plan data stay intact.")
        }
    }

    // MARK: - Profile

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            sectionHeader("Profile")
            row("Name",    UserProfile.name)
            row("Sex",     UserProfile.sex)
            row("Age",     "\(UserProfile.age)")
            row("Height",  UserProfile.heightDisplay)
            row("Start",   String(format: "%.0f kg", UserProfile.startingWeightKg))
            row("Goal",    String(format: "%.0f kg", UserProfile.goalWeightKg))
            row("Location", UserProfile.location)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    // MARK: - Plan

    private var planCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            sectionHeader("Plan")
            row("Day",   "\(PlanTargets.dayOfPlan) of \(PlanTargets.planLengthDays)")
            row("Week",  "\(PlanTargets.weekOfPlan) of \(PlanTargets.planLengthWeeks)")
            row("Start", planStartDisplay)
            row("Daily kcal",   "\(PlanTargets.calories)")
            row("Protein / Carbs / Fat",
                String(format: "%.0f / %.0f / %.0f g",
                       PlanTargets.protein, PlanTargets.carbs, PlanTargets.fat))
            row("Water", String(format: "%.1f L", PlanTargets.waterLiters))

            Button(role: .destructive) { resetPlanStart() } label: {
                Label("Reset plan start to today", systemImage: "arrow.counterclockwise")
                    .font(DS.Font.bodyEmphasised)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DS.Spacing.xs)
                    .background(DS.Color.accentSecondary.opacity(0.18))
                    .foregroundStyle(DS.Color.accentSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.top, DS.Spacing.xs)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    private var planStartDisplay: String {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        return f.string(from: PlanTargets.planStartDate)
    }

    // MARK: - Reminders

    private var remindersCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            sectionHeader("Reminders")
            if reminders.isEmpty {
                Text("No reminders scheduled.")
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textSecondary)
            } else {
                ForEach(reminders, id: \.id) { r in
                    reminderRow(r)
                    if r.id != reminders.last?.id {
                        Divider().background(DS.Color.surfaceElevated)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    @ViewBuilder
    private func reminderRow(_ r: ReminderConfig) -> some View {
        Button { editing = r } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: DS.Spacing.xs) {
                        Text(r.time)
                            .font(DS.Font.captionEmphasised)
                            .foregroundStyle(DS.Color.textSecondary)
                            .monospacedDigit()
                        Text(r.type)
                            .font(DS.Font.caption)
                            .foregroundStyle(DS.Color.textSecondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 1)
                            .background(DS.Color.surfaceElevated)
                            .clipShape(Capsule())
                    }
                    Text(r.title)
                        .font(DS.Font.titleMedium)
                        .foregroundStyle(DS.Color.textPrimary)
                }
                Spacer()
                Toggle("", isOn: binding(for: r))
                    .labelsHidden()
                    .tint(DS.Color.accentPrimary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    private func binding(for config: ReminderConfig) -> Binding<Bool> {
        Binding(
            get: { config.enabled },
            set: { newValue in
                config.enabled = newValue
                try? context.save()
                Task { await NotificationService.sync(configs: reminders, context: context) }
            }
        )
    }

    // MARK: - Data

    private var dataCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            sectionHeader("Data")

            if let url = exportURL {
                ShareLink(item: url) {
                    Label("Share export", systemImage: "square.and.arrow.up")
                        .font(DS.Font.bodyEmphasised)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DS.Spacing.sm)
                        .background(DS.Color.accentPrimary)
                        .foregroundStyle(DS.Color.background)
                        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
                }
                .buttonStyle(.plain)
            } else {
                Button { exportURL = DataExporter.writeTemporaryFile(from: context) } label: {
                    Label("Build JSON export", systemImage: "doc.text")
                        .font(DS.Font.bodyEmphasised)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DS.Spacing.sm)
                        .background(DS.Color.accentPrimary)
                        .foregroundStyle(DS.Color.background)
                        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
                }
                .buttonStyle(.plain)
            }

            Button(role: .destructive) { showWipeConfirm = true } label: {
                Label("Wipe logged data", systemImage: "trash")
                    .font(DS.Font.bodyEmphasised)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DS.Spacing.sm)
                    .background(DS.Color.accentSecondary.opacity(0.18))
                    .foregroundStyle(DS.Color.accentSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    // MARK: - About

    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            sectionHeader("About")
            row("App",     "NexusWorkout")
            row("Version", Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—")
            row("Build",   Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—")
            Text("Offline-only · data stays on this device.")
                .font(DS.Font.caption)
                .foregroundStyle(DS.Color.textSecondary)
                .padding(.top, DS.Spacing.xs)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    // MARK: - Helpers

    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(DS.Font.captionEmphasised)
            .foregroundStyle(DS.Color.textSecondary)
            .textCase(.uppercase)
    }

    @ViewBuilder
    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textSecondary)
            Spacer()
            Text(value)
                .font(DS.Font.bodyEmphasised)
                .foregroundStyle(DS.Color.textPrimary)
                .monospacedDigit()
        }
    }

    private var editingBinding: Binding<Bool> {
        Binding(
            get: { editing != nil },
            set: { if !$0 { editing = nil } }
        )
    }

    // MARK: - Actions

    private func resetPlanStart() {
        let today = Calendar.current.startOfDay(for: .now)
        UserDefaults.standard.set(today, forKey: "PlanTargets.planStartDate")
    }

    private func wipeAll() {
        let types: [any PersistentModel.Type] = [
            WorkoutSession.self,
            LoggedExercise.self,
            LoggedSet.self,
            MealLog.self,
            SupplementLog.self,
            BodyMetric.self,
            ProgressPhoto.self,
            DailyLog.self,
        ]
        for t in types {
            try? context.delete(model: t)
        }
        try? context.save()
        exportURL = nil
    }
}
