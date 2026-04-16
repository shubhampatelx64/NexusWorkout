//
//  LogMetricSheet.swift
//  NexusWorkout
//
//  Modal sheet for adding a new BodyMetric row.  All fields are
//  optional — leave anything blank and it stays nil.  Weight and
//  waist are the two the plan actually tracks; chest / hips / thigh
//  are convenience fields for anyone who wants tape-measure detail.
//

import SwiftUI
import SwiftData

struct LogMetricSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss)      private var dismiss

    @State private var date: Date = .now
    @State private var weightKg: String = ""
    @State private var waistCm:  String = ""
    @State private var chestCm:  String = ""
    @State private var hipsCm:   String = ""
    @State private var thighCm:  String = ""
    @State private var notes:    String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("When") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                Section("Primary") {
                    numericField("Weight", unit: "kg", text: $weightKg)
                    numericField("Waist",  unit: "cm", text: $waistCm)
                }
                Section("Optional") {
                    numericField("Chest", unit: "cm", text: $chestCm)
                    numericField("Hips",  unit: "cm", text: $hipsCm)
                    numericField("Thigh", unit: "cm", text: $thighCm)
                }
                Section("Notes") {
                    TextField("Anything worth remembering", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Log measurement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!hasAnyValue)
                }
            }
        }
    }

    @ViewBuilder
    private func numericField(_ label: String, unit: String, text: Binding<String>) -> some View {
        HStack {
            Text(label)
            Spacer()
            TextField("—", text: text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 80)
            Text(unit)
                .foregroundStyle(DS.Color.textSecondary)
                .frame(width: 24, alignment: .leading)
        }
    }

    private var hasAnyValue: Bool {
        !weightKg.isEmpty || !waistCm.isEmpty ||
        !chestCm.isEmpty  || !hipsCm.isEmpty  ||
        !thighCm.isEmpty
    }

    private func save() {
        let metric = BodyMetric(
            date: date,
            weightKg: Double(weightKg),
            waistCm:  Double(waistCm),
            chestCm:  Double(chestCm),
            hipsCm:   Double(hipsCm),
            thighCm:  Double(thighCm),
            notes:    notes.isEmpty ? nil : notes
        )
        context.insert(metric)
        try? context.save()
        dismiss()
    }
}
