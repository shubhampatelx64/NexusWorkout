//
//  SetLogRow.swift
//  NexusWorkout
//
//  One editable row for a LoggedSet — set number, weight (kg),
//  reps, and a check button that fires the rest-timer callback.
//  Edits write through @Bindable straight to the model context.
//

import SwiftUI

struct SetLogRow: View {
    @Bindable var set: LoggedSet
    let onComplete: () -> Void

    @State private var didComplete: Bool = false

    var body: some View {
        HStack(spacing: DS.Spacing.sm) {
            Text("Set \(set.setNumber)")
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textSecondary)
                .frame(width: 56, alignment: .leading)

            weightField
            repsField

            Spacer(minLength: 0)

            Button {
                onComplete()
                didComplete = true
            } label: {
                Image(systemName: didComplete ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(didComplete
                                     ? DS.Color.accentPrimary
                                     : DS.Color.textSecondary)
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.success, trigger: didComplete)
        }
        .padding(.vertical, 4)
    }

    // MARK: - Fields

    private var weightField: some View {
        numericField(
            value: Binding(
                get: { set.weight },
                set: { set.weight = $0 }
            ),
            placeholder: "0",
            unit: "kg",
            keyboard: .decimalPad,
            width: 64
        )
    }

    private var repsField: some View {
        numericField(
            value: Binding(
                get: { Double(set.reps) },
                set: { set.reps = Int($0) }
            ),
            placeholder: "0",
            unit: "reps",
            keyboard: .numberPad,
            width: 56
        )
    }

    private func numericField(
        value: Binding<Double>,
        placeholder: String,
        unit: String,
        keyboard: UIKeyboardType,
        width: CGFloat
    ) -> some View {
        HStack(spacing: 4) {
            TextField(placeholder, value: value, format: .number)
                .keyboardType(keyboard)
                .font(DS.Font.bodyEmphasised)
                .foregroundStyle(DS.Color.textPrimary)
                .multilineTextAlignment(.trailing)
                .monospacedDigit()
                .frame(width: width)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
                .background(DS.Color.surfaceElevated)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            Text(unit)
                .font(DS.Font.caption)
                .foregroundStyle(DS.Color.textSecondary)
        }
    }
}
