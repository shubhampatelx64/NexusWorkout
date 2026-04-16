//
//  TodayView.swift
//  NexusWorkout
//
//  Daily dashboard.  Composed entirely of small cards under
//  Views/Today/ — this file just wires data + actions and stacks them
//  in a scroll view.
//
//  Render order matches the priority of "what does Shubham need to
//  see / do RIGHT NOW":
//      1. Today's workout (most actionable)
//      2. Macros progress (today's biggest variable)
//      3. Meals (one-tap log)
//      4. Water (kidney-stone risk → never let it slip)
//      5. Journal (sleep / energy)
//

import SwiftUI
import SwiftData

struct TodayView: View {

    // MARK: - Queries

    @Query(sort: \DailyLog.date, order: .reverse)
    private var allDailyLogs: [DailyLog]

    @Query(sort: \MealLog.date, order: .reverse)
    private var allMealLogs: [MealLog]

    @Query(sort: \MealTemplate.suggestedTime)
    private var allMealTemplates: [MealTemplate]

    @Query private var allWorkouts: [WorkoutTemplate]

    @Environment(\.modelContext) private var context

    // MARK: - Local state

    @State private var todayLog: DailyLog?

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.md) {
                header

                TodayWorkoutCard(template: todaysWorkout)

                TodayMacrosCard(consumed: consumed)

                TodayMealsCard(
                    templates: todaysMealTemplates,
                    loggedTemplateIDs: loggedMealTemplateIDs,
                    onLog: logMeal(_:)
                )

                if let todayLog {
                    TodayWaterCard(log: todayLog, onChange: persist)
                    TodayJournalCard(log: todayLog, onChange: persist)
                }
            }
            .padding(.horizontal, DS.Spacing.md)
            .padding(.vertical, DS.Spacing.md)
        }
        .dsBackground()
        .navigationTitle("Today")
        .navigationBarTitleDisplayMode(.large)
        .task { todayLog = ensureTodayLog() }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
            Text(formattedDate)
                .font(DS.Font.captionEmphasised)
                .foregroundStyle(DS.Color.textSecondary)
                .textCase(.uppercase)
            HStack(alignment: .firstTextBaseline, spacing: DS.Spacing.sm) {
                Text("Day \(PlanTargets.dayOfPlan)")
                    .font(DS.Font.displayMedium)
                    .foregroundStyle(DS.Color.textPrimary)
                Text("of \(PlanTargets.planLengthDays) · Week \(PlanTargets.weekOfPlan)")
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, d MMM"
        return f.string(from: .now)
    }

    // MARK: - Derived data

    private var todaysWorkout: WorkoutTemplate? {
        let weekday = isoWeekday(from: .now)
        return allWorkouts.first(where: {
            $0.split == "5-day" && $0.dayOfWeek == weekday
        })
    }

    private var todaysMealTemplates: [MealTemplate] {
        let weekday = isoWeekday(from: .now)
        return allMealTemplates
            .filter { $0.dayOfWeek == weekday }
            .sorted { $0.suggestedTime < $1.suggestedTime }
    }

    private var todaysMealLogs: [MealLog] {
        allMealLogs.filter {
            Calendar.current.isDate($0.date, inSameDayAs: .now)
        }
    }

    private var loggedMealTemplateIDs: Set<UUID> {
        Set(todaysMealLogs.compactMap { $0.template?.id })
    }

    private var consumed: MacroTotals {
        var t = MacroTotals.zero
        for log in todaysMealLogs {
            t.calories += log.calories
            t.protein  += log.protein
            t.carbs    += log.carbs
            t.fat      += log.fat
        }
        return t
    }

    // MARK: - Actions

    private func ensureTodayLog() -> DailyLog {
        let day = Calendar.current.startOfDay(for: .now)
        if let existing = allDailyLogs.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: day)
        }) {
            return existing
        }
        let new = DailyLog(date: day)
        context.insert(new)
        try? context.save()
        return new
    }

    private func logMeal(_ template: MealTemplate) {
        let log = MealLog(
            date: .now,
            mealType: template.mealType,
            items: template.items,
            calories: template.calories,
            protein: template.protein,
            carbs: template.carbs,
            fat: template.fat,
            template: template
        )
        context.insert(log)
        try? context.save()
    }

    private func persist() {
        try? context.save()
    }
}

// MARK: - Shared

struct MacroTotals {
    var calories: Int
    var protein:  Double
    var carbs:    Double
    var fat:      Double

    static let zero = MacroTotals(calories: 0, protein: 0, carbs: 0, fat: 0)
}

/// Calendar.current returns Sun=1..Sat=7.
/// The app's data schema uses ISO weekdays — Mon=1..Sun=7.
func isoWeekday(from date: Date) -> Int {
    let cal = Calendar.current.component(.weekday, from: date)
    return ((cal + 5) % 7) + 1
}
