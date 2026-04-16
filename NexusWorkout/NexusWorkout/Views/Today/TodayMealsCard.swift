//
//  TodayMealsCard.swift
//  NexusWorkout
//
//  Today's 5 meal slots, sorted by suggested time.  Each row collapses
//  the full plan into one tappable line — name + macros + a checkbox
//  that creates a MealLog entry on first tap.
//
//  Logged meals stay visually disabled (they cannot be un-logged from
//  this card — that's an Eat-tab affordance to avoid accidental taps).
//

import SwiftUI

struct TodayMealsCard: View {
    let templates: [MealTemplate]
    let loggedTemplateIDs: Set<UUID>
    let onLog: (MealTemplate) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack {
                Text("Meals")
                    .font(DS.Font.titleMedium)
                    .foregroundStyle(DS.Color.textPrimary)
                Spacer()
                Text("\(loggedTemplateIDs.count) / \(templates.count) logged")
                    .font(DS.Font.captionEmphasised)
                    .foregroundStyle(DS.Color.textSecondary)
                    .monospacedDigit()
            }

            VStack(spacing: 0) {
                ForEach(Array(templates.enumerated()), id: \.element.id) { index, meal in
                    MealRow(
                        meal: meal,
                        isLogged: loggedTemplateIDs.contains(meal.id),
                        onLog: { onLog(meal) }
                    )
                    if index < templates.count - 1 {
                        Divider().background(DS.Color.surfaceElevated)
                    }
                }
            }
        }
        .dsCard()
    }
}

private struct MealRow: View {
    let meal: MealTemplate
    let isLogged: Bool
    let onLog: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: DS.Spacing.sm) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: DS.Spacing.xs) {
                    Text(meal.suggestedTime)
                        .font(DS.Font.captionEmphasised)
                        .foregroundStyle(DS.Color.textSecondary)
                        .monospacedDigit()
                    Text(meal.mealType.capitalized)
                        .font(DS.Font.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 1)
                        .background(DS.Color.surfaceElevated)
                        .clipShape(Capsule())
                }
                Text(meal.name)
                    .font(DS.Font.bodyEmphasised)
                    .foregroundStyle(DS.Color.textPrimary)
                    .lineLimit(1)
                Text("\(meal.calories) kcal · \(Int(meal.protein))P / \(Int(meal.carbs))C / \(Int(meal.fat))F")
                    .font(DS.Font.caption)
                    .foregroundStyle(DS.Color.textSecondary)
                    .monospacedDigit()
            }

            Spacer(minLength: DS.Spacing.sm)

            Button(action: onLog) {
                Image(systemName: isLogged ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundStyle(isLogged ? DS.Color.accentPrimary : DS.Color.textSecondary)
            }
            .buttonStyle(.plain)
            .disabled(isLogged)
            .sensoryFeedback(.success, trigger: isLogged)
        }
        .padding(.vertical, DS.Spacing.xs)
        .opacity(isLogged ? 0.7 : 1)
    }
}
