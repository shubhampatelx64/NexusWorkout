//
//  MealCard.swift
//  NexusWorkout
//
//  Full-detail meal card used inside the Eat tab.  Unlike the
//  Today-card row this one shows the full `items` description
//  (multi-line) and supports BOTH logging and un-logging — that's
//  why this card is the un-log escape hatch for accidental Today
//  taps.
//

import SwiftUI

struct MealCard: View {
    let meal: MealTemplate
    let isLoggedToday: Bool
    let canLog: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack(alignment: .top) {
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
                        .font(DS.Font.titleMedium)
                        .foregroundStyle(DS.Color.textPrimary)
                }
                Spacer()
                if canLog {
                    Button(action: onToggle) {
                        Image(systemName: isLoggedToday ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 28, weight: .regular))
                            .foregroundStyle(isLoggedToday
                                             ? DS.Color.accentPrimary
                                             : DS.Color.textSecondary)
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.selection, trigger: isLoggedToday)
                }
            }

            Text(meal.items)
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("\(meal.calories) kcal")
                    .font(DS.Font.captionEmphasised)
                    .foregroundStyle(DS.Color.textPrimary)
                Spacer()
                Text("\(Int(meal.protein))P · \(Int(meal.carbs))C · \(Int(meal.fat))F")
                    .font(DS.Font.captionEmphasised)
                    .foregroundStyle(DS.Color.textSecondary)
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
        .opacity(isLoggedToday ? 0.85 : 1)
    }
}
