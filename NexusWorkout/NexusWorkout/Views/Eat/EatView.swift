//
//  EatView.swift
//  NexusWorkout
//
//  Eat tab root.  Two-pane segmented control:
//    Plan         — week view; pick a day, see its 5 meals, log the
//                   ones you actually ate (only enabled for today).
//    Supplements  — today's 6-supplement checklist.
//
//  Logging from this tab also gives the user a way to UN-log a meal
//  that was checked accidentally on the Today card — that affordance
//  was deliberately omitted there to avoid mis-taps.
//

import SwiftUI

struct EatView: View {
    @State private var pane: Pane = .plan
    @State private var selectedDay: Int = isoWeekday(from: .now)

    enum Pane: String, CaseIterable, Identifiable {
        case plan        = "Plan"
        case supplements = "Supplements"
        var id: String { rawValue }
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $pane) {
                ForEach(Pane.allCases) { p in Text(p.rawValue).tag(p) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, DS.Spacing.md)
            .padding(.vertical, DS.Spacing.sm)
            .background(DS.Color.background)

            switch pane {
            case .plan:        MealPlanPane(selectedDay: $selectedDay)
            case .supplements: SupplementsPane()
            }
        }
        .dsBackground()
        .navigationTitle("Eat")
        .navigationBarTitleDisplayMode(.large)
    }
}
