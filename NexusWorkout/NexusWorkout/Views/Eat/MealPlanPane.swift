//
//  MealPlanPane.swift
//  NexusWorkout
//
//  Day-of-week picker + the 5 meals planned for that day.  Daily
//  totals card sits between them so you can scan calories / macros
//  before drilling into individual meals.
//
//  Logging is only enabled when the selected day matches today, so
//  navigating back to "what am I supposed to eat Wednesday?" doesn't
//  accidentally create today's MealLog rows for Wednesday's meals.
//

import SwiftUI
import SwiftData

struct MealPlanPane: View {
    @Binding var selectedDay: Int

    @Query(sort: \MealTemplate.suggestedTime)
    private var allTemplates: [MealTemplate]

    @Query(sort: \MealLog.date, order: .reverse)
    private var allMealLogs: [MealLog]

    @Environment(\.modelContext) private var context

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.md) {
                dayPicker
                summaryCard
                ForEach(meals, id: \.id) { meal in
                    MealCard(
                        meal: meal,
                        isLoggedToday: isLoggedToday(meal),
                        canLog: isToday,
                        onToggle: { toggleLog(meal) }
                    )
                }
            }
            .padding(DS.Spacing.md)
        }
    }

    // MARK: - Subviews

    private var dayPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DS.Spacing.xs) {
                ForEach(1...7, id: \.self) { day in
                    DayChip(
                        day: day,
                        isSelected: day == selectedDay,
                        isToday:    day == isoWeekday(from: .now),
                        onTap:      { selectedDay = day }
                    )
                }
            }
        }
    }

    private var summaryCard: some View {
        let totals = totals(for: meals)
        return VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Text(longDayLabel(selectedDay) + (isToday ? " · today" : ""))
                .font(DS.Font.captionEmphasised)
                .foregroundStyle(DS.Color.textSecondary)
                .textCase(.uppercase)
            HStack(alignment: .firstTextBaseline) {
                Text("\(totals.calories) kcal")
                    .font(DS.Font.displaySmall)
                    .foregroundStyle(DS.Color.textPrimary)
                Spacer()
                Text("\(Int(totals.protein))P  \(Int(totals.carbs))C  \(Int(totals.fat))F")
                    .font(DS.Font.bodyEmphasised)
                    .foregroundStyle(DS.Color.textSecondary)
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    // MARK: - Derived

    private var meals: [MealTemplate] {
        allTemplates
            .filter { $0.dayOfWeek == selectedDay }
            .sorted { $0.suggestedTime < $1.suggestedTime }
    }

    private var isToday: Bool {
        selectedDay == isoWeekday(from: .now)
    }

    private var todaysLogs: [MealLog] {
        allMealLogs.filter {
            Calendar.current.isDate($0.date, inSameDayAs: .now)
        }
    }

    private func isLoggedToday(_ template: MealTemplate) -> Bool {
        todaysLogs.contains(where: { $0.template?.id == template.id })
    }

    private func totals(for templates: [MealTemplate]) -> MacroTotals {
        var t = MacroTotals.zero
        for m in templates {
            t.calories += m.calories
            t.protein  += m.protein
            t.carbs    += m.carbs
            t.fat      += m.fat
        }
        return t
    }

    // MARK: - Actions

    private func toggleLog(_ template: MealTemplate) {
        if let existing = todaysLogs.first(where: { $0.template?.id == template.id }) {
            context.delete(existing)
        } else {
            let new = MealLog(
                date: .now,
                mealType: template.mealType,
                items: template.items,
                calories: template.calories,
                protein: template.protein,
                carbs: template.carbs,
                fat: template.fat,
                template: template
            )
            context.insert(new)
        }
        try? context.save()
    }
}

// MARK: - Day chip

private struct DayChip: View {
    let day: Int
    let isSelected: Bool
    let isToday: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text(shortDayLabel(day))
                    .font(DS.Font.captionEmphasised)
                Text(isToday ? "today" : " ")
                    .font(.system(size: 9, weight: .medium))
            }
            .frame(width: 44)
            .padding(.vertical, 6)
            .background(isSelected ? DS.Color.accentPrimary : DS.Color.surfaceElevated)
            .foregroundStyle(isSelected ? DS.Color.background : DS.Color.textPrimary)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

private func shortDayLabel(_ day: Int) -> String {
    ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][max(0, min(6, day - 1))]
}

private func longDayLabel(_ day: Int) -> String {
    ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][max(0, min(6, day - 1))]
}
