//
//  TrainView.swift
//  NexusWorkout
//
//  Train tab root.  Two-pane segmented control:
//    Workouts  — split toggle (5-day / 6-day) + template list
//    Library   — search + filter the 39-exercise catalog
//
//  Tapping a workout pushes ActiveSessionView; tapping an exercise
//  pushes ExerciseDetailView.  Both destinations are declared here so
//  the Train NavigationStack handles them; Today declares its own.
//

import SwiftUI
import SwiftData

struct TrainView: View {
    @State private var pane: Pane = .workouts

    enum Pane: String, CaseIterable, Identifiable {
        case workouts = "Workouts"
        case library  = "Library"
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
            case .workouts: WorkoutBrowserPane()
            case .library:  ExerciseLibraryView()
            }
        }
        .dsBackground()
        .navigationTitle("Train")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: WorkoutTemplate.self) { tpl in
            ActiveSessionView(template: tpl)
        }
        .navigationDestination(for: Exercise.self) { ex in
            ExerciseDetailView(exercise: ex)
        }
    }
}

private struct WorkoutBrowserPane: View {
    @Query(sort: [SortDescriptor(\WorkoutTemplate.dayOfWeek)])
    private var allWorkouts: [WorkoutTemplate]

    @State private var split: String = "5-day"

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.md) {
                Picker("Split", selection: $split) {
                    Text("5-day").tag("5-day")
                    Text("6-day").tag("6-day")
                }
                .pickerStyle(.segmented)

                ForEach(filtered, id: \.id) { tpl in
                    NavigationLink(value: tpl) {
                        TrainTemplateCard(template: tpl)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(DS.Spacing.md)
        }
    }

    private var filtered: [WorkoutTemplate] {
        allWorkouts
            .filter { $0.split == split }
            .sorted { ($0.dayOfWeek ?? 0) < ($1.dayOfWeek ?? 0) }
    }
}
