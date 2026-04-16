//
//  GroceryPane.swift
//  NexusWorkout
//
//  Shopping-list view derived from MealTemplate.items strings.  Two
//  scopes: today's five meals (small list — useful for a quick run
//  to the dukaan) and the entire 7-day plan (bigger list — useful
//  for the weekend Saturday-morning haul).
//
//  Parsing strategy: split each meal's `items` on ";" (the catalogs
//  already use that as the ingredient separator), trim whitespace
//  and trailing periods, then dedupe case-insensitively across the
//  selected scope so repeat ingredients like "2 multigrain rotis"
//  don't appear five times in the weekly list.
//
//  Check state is transient — @State only, resets on pane switch or
//  scope change.  Shopping is a one-trip action; we're not trying
//  to be a task manager.
//

import SwiftUI
import SwiftData

struct GroceryPane: View {
    @Query(sort: \MealTemplate.suggestedTime)
    private var allTemplates: [MealTemplate]

    @State private var scope: Scope = .today
    @State private var checked: Set<String> = []

    enum Scope: String, CaseIterable, Identifiable {
        case today = "Today"
        case week  = "Week"
        var id: String { rawValue }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.md) {
                scopePicker
                summaryCard
                if items.isEmpty {
                    emptyState
                } else {
                    VStack(spacing: DS.Spacing.xs) {
                        ForEach(Array(items.enumerated()), id: \.offset) { _, phrase in
                            row(phrase)
                        }
                    }
                    clearButton
                }
            }
            .padding(DS.Spacing.md)
        }
    }

    // MARK: - Subviews

    private var scopePicker: some View {
        Picker("", selection: $scope) {
            ForEach(Scope.allCases) { Text($0.rawValue).tag($0) }
        }
        .pickerStyle(.segmented)
        .onChange(of: scope) { _, _ in checked.removeAll() }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
            Text(scopeLabel)
                .font(DS.Font.captionEmphasised)
                .foregroundStyle(DS.Color.textSecondary)
                .textCase(.uppercase)
            HStack(alignment: .firstTextBaseline) {
                Text("\(checkedInScope) / \(items.count)")
                    .font(DS.Font.displaySmall)
                    .foregroundStyle(DS.Color.textPrimary)
                    .monospacedDigit()
                Text(items.count == 1 ? "item checked" : "items checked")
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
            Image(systemName: "basket")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(DS.Color.accentPrimary)
            Text("No meals in this scope")
                .font(DS.Font.titleMedium)
                .foregroundStyle(DS.Color.textPrimary)
            Text("Meal templates ship with the seed data; if you're seeing this, try reinstalling the app.")
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.Spacing.lg)
        .dsCard()
    }

    @ViewBuilder
    private func row(_ phrase: String) -> some View {
        let isChecked = checked.contains(phrase.lowercased())
        Button {
            let key = phrase.lowercased()
            if isChecked { checked.remove(key) } else { checked.insert(key) }
        } label: {
            HStack(alignment: .top, spacing: DS.Spacing.sm) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(isChecked ? DS.Color.accentPrimary : DS.Color.textSecondary)
                Text(phrase)
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .strikethrough(isChecked)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, DS.Spacing.sm)
            .padding(.horizontal, DS.Spacing.md)
            .background(DS.Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
            .opacity(isChecked ? 0.7 : 1)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isChecked)
    }

    private var clearButton: some View {
        Button { checked.removeAll() } label: {
            Label("Clear ticks", systemImage: "arrow.counterclockwise")
                .font(DS.Font.captionEmphasised)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DS.Spacing.xs)
                .foregroundStyle(DS.Color.textSecondary)
        }
        .buttonStyle(.plain)
        .disabled(checked.isEmpty)
        .opacity(checked.isEmpty ? 0.4 : 1)
    }

    // MARK: - Derived

    private var scopeLabel: String {
        switch scope {
        case .today: return longDay(isoWeekday(from: .now)) + "'s shopping"
        case .week:  return "Full-week shopping"
        }
    }

    private var scopedMeals: [MealTemplate] {
        switch scope {
        case .today:
            let d = isoWeekday(from: .now)
            return allTemplates.filter { $0.dayOfWeek == d }
        case .week:
            return allTemplates
        }
    }

    private var items: [String] {
        let phrases = scopedMeals.flatMap { meal -> [String] in
            meal.items
                .split(separator: ";")
                .map { chunk -> String in
                    let s = chunk.trimmingCharacters(in: .whitespacesAndNewlines)
                    return s.trimmingCharacters(in: CharacterSet(charactersIn: "."))
                }
                .filter { !$0.isEmpty }
        }
        var seen = Set<String>()
        var result: [String] = []
        for p in phrases {
            let key = p.lowercased()
            if seen.insert(key).inserted {
                result.append(p)
            }
        }
        return result
    }

    private var checkedInScope: Int {
        let keys = Set(items.map { $0.lowercased() })
        return checked.intersection(keys).count
    }

    private func longDay(_ day: Int) -> String {
        ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"][max(0, min(6, day - 1))]
    }
}
