//
//  ProgressTabView.swift
//  NexusWorkout
//
//  Progress tab root.  Three-pane segmented control:
//    Metrics  — weight / waist / body composition trends over time
//    Lifts    — PRs (top estimated 1RM per exercise) from logged sets
//    Photos   — dated progress-photo grid, front / side / back poses
//
//  Lives under Views/Progress/ and replaces the stub formerly in
//  TabStubs.swift.
//

import SwiftUI

struct ProgressTabView: View {
    @State private var pane: Pane = .metrics

    enum Pane: String, CaseIterable, Identifiable {
        case metrics = "Metrics"
        case lifts   = "Lifts"
        case photos  = "Photos"
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
            case .metrics: MetricsPane()
            case .lifts:   LiftPRPane()
            case .photos:  PhotosPane()
            }
        }
        .dsBackground()
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
    }
}
